import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/staff_confirmation_controller.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:get/get.dart';
import 'package:folder_structure/controller/core_controller.dart';

import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/edit_profile_screen.dart';

class StaffHomePage extends StatelessWidget {
  final coreController = Get.put(CoreController());
  // final historyController = Get.put(HistoryScreenController());
  final orderConfirmController = Get.put(StaffConfirmationController());

  StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (coreController.currentUser.value?.role != 'staff') {
        return Scaffold(
          body: Center(
            child: Text("Access Denied: Staff only page"),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "Staff Dashboard",
            style: CustomTextStyles.f18W600(color: AppColors.whiteColor),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Column(
          children: [
            _buildUserProfileCard(),
            Expanded(
              child: _buildPendingOrdersList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildUserProfileCard() {
    return Obx(() {
      final user = coreController.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(
                "${user.firstName?[0]}${user.lastName?[0]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${user.email}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${user.role}".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: () {
                Get.to(() => EditProfileScreen());
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPendingOrdersList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          orderConfirmController.allOrderHistory.clear();
          await orderConfirmController.filterOrderdDetails();
        },
        child: Obx(() {
          if (orderConfirmController.loadings.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderConfirmController.allOrderHistory.isEmpty) {
            return const Center(child: Text("No Order Available"));
          }

          return ListView.builder(
            itemCount: orderConfirmController.allOrderHistory.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final order = orderConfirmController.allOrderHistory[index];
              final user = order.userDetails;
              final item = (order.items != null && order.items!.isNotEmpty)
                  ? order.items!.first
                  : null;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username: ${user?.name ?? 'Unknown'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Ordered id: ${order.orderId ?? '-'}"),
                    const SizedBox(height: 4),
                    Text("Ordered Item: ${item?.foodName ?? '-'}"),
                    const SizedBox(height: 4),
                    Text("Total Price: Rs. ${order.totalAmount}"),
                    const SizedBox(height: 4),
                    Text(
                      "Status: ${order.orderStatus}",
                      style: const TextStyle(color: Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    if (order.orderStatus == 'pending')
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () async {
                            orderConfirmController.confirmOrder(
                                order.orderId.toString(),
                                order.totalAmount.toString());
                          },
                          child: const Text("Confirm Order"),
                        ),
                      ),
                    if (order.orderStatus == 'confirmed' &&
                        order.payment!.paymentStatus == 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () async {
                            orderConfirmController.changePaymentStatus(
                                order.payment!.paymentId.toString());
                          },
                          child: const Text("Delivered"),
                        ),
                      ),
                    if (order.payment!.paymentStatus == 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Delivered",
                            style: CustomTextStyles.f14W600(
                                color: AppColors.accept),
                          ),
                        ],
                      )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Obx(() {
  //   final orders = historyController.allOrderHistory
  //       .where((order) => order.orderStatus?.toLowerCase() == 'pending')
  //       .toList();

  //   if (orders.isEmpty) {
  //     return const Center(child: Text("No pending orders."));
  //   }

  //   return ListView.builder(
  //     itemCount: orders.length,
  //     itemBuilder: (context, index) {
  //       final order = orders[index];
  //       final user = order.userDetails;
  //       final item = order.items?.first;
  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 12),
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 6,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text("Username: ${user?.name ?? 'Unknown'}",
  //                 style: const TextStyle(fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 4),
  //             Text("Ordered Item: ${item?.foodName ?? '-'}"),
  //             const SizedBox(height: 4),
  //             Text("Total Price: Rs. ${order.totalAmount}"),
  //             const SizedBox(height: 4),
  //             Text("Status: ${order.orderStatus}",
  //                 style: const TextStyle(color: Colors.orange)),
  //             const SizedBox(height: 12),
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.primaryColor,
  //                 ),
  //                 onPressed: () async {
  //                   // final staffId = coreController.currentUser.value?.id;
  //                   // final orderId = order.orderId;
  //                   // final amount = order.totalAmount;

  //                   // final response = await http.post(
  //                   //   Uri.parse(Api.confirmOrderUrl),
  //                   //   body: {
  //                   //     'order_id': orderId ?? '',
  //                   //     'staff_id': staffId ?? '',
  //                   //     'payment_amount': amount ?? '',
  //                   //   },
  //                   // );

  //                   // final res = response.body;
  //                   // if (response.statusCode == 200 &&
  //                   //     res.contains('success')) {
  //                   //   CustomSnackBar.success(
  //                   //       title: "Success", message: "Order confirmed!");
  //                   //   historyController.getAllOrders();
  //                   // } else {
  //                   //   CustomSnackBar.error(
  //                   //       title: "Error",
  //                   //       message: "Failed to confirm order");
  //                   // }
  //                   orderConfirmController.confirmOrder(
  //                       order.orderId.toString(),
  //                       order.totalAmount.toString());
  //                 },
  //                 child: const Text("Confirm Order"),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }),
}

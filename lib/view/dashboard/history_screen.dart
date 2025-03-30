import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/history_screen_controller.dart';
import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/history_detail_screen.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryScreenController controller = Get.put(HistoryScreenController());

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text("Order History",
            style: CustomTextStyles.f18W600(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(onRefresh: () async {
        controller.allOrderHistory.clear();
        controller.getAllOrders();
      }, child: Obx(() {
        return (controller.loadings.value)
            ? const Center(child: CircularProgressIndicator())
            : controller.allOrderHistory.isEmpty
                ? const Center(child: Text("No Order Available"))
                : ListView.builder(
                    itemCount: controller.allOrderHistory.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final order = controller.allOrderHistory[index];

                      return OrderHistoryWidget(order: order);
                    },
                  );
      })),
    );
  }
}

class OrderHistoryWidget extends StatelessWidget {
  const OrderHistoryWidget({
    super.key,
    required this.order,
  });

  final OrderHistory order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => HistoryDetailScreen(order: order));
      },
      child: Card(
        color: AppColors.whiteColor,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: ${order.orderId}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.orderStatus ?? 'Pending',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 5),

              // Payment Method
              Text(
                'Payment Method: ${order.payment!.method ?? 'N/A'}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 5),

              // Items List
              Text(
                'Items: ${order.items?.map((item) => item.foodName).join(', ') ?? 'No items'}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 5),

              // Total Price
              Text(
                'Total Price: \RS ${order.totalAmount ?? '0'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

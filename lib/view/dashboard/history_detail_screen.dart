import 'package:flutter/material.dart';
import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:get/get.dart';

class HistoryDetailScreen extends StatelessWidget {
  final OrderHistory order;

  const HistoryDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildTopBackground(size),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderDetailCard(
                            Icons.receipt,
                            'Order ID',
                            order.orderId ?? "",
                            color: AppColors.primaryColor,
                          ),
                          _buildOrderDetailCard(
                            Icons.timelapse,
                            'Order Status',
                            order.orderStatus ?? 'Pending',
                            color: Colors.green,
                          ),
                          _buildOrderDetailCard(
                            Icons.payment,
                            'Payment Method',
                            order.payment?.method ?? 'N/A',
                            color: Colors.orange,
                          ),
                          _buildOrderDetailCard(
                            Icons.fastfood,
                            'Items',
                            order.items
                                    ?.map((item) => item.foodName)
                                    .join(', ') ??
                                'No items',
                            color: Colors.purple,
                          ),
                          _buildOrderDetailCard(
                            Icons.attach_money,
                            'Total Price',
                            'Rs ${order.totalAmount ?? '0'}',
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Payment Status'),
                          const SizedBox(height: 12),
                          _buildPaymentStatusSection(
                              order.orderStatus ?? 'N/A'),
                          const SizedBox(height: 24),
                          if ((order.orderStatus?.toLowerCase() ?? "") ==
                              'pending')
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "Cancel Order",
                                    middleText:
                                        "Are you sure you want to cancel this order?",
                                    textConfirm: "Yes",
                                    textCancel: "No",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      Get.back();
                                      Get.snackbar("Cancelled",
                                          "Order has been cancelled.");
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel Order",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBackground(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.25,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 20,
              child: _buildCircle(80),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: _buildCircle(60),
            ),
            Positioned(
              bottom: 40,
              left: 100,
              child: _buildCircle(40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
          const Spacer(),
          const Text(
            "Order Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildOrderDetailCard(IconData icon, String title, String value,
      {Color color = Colors.blue}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.payments_outlined,
              color: AppColors.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800]),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusSection(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'processing':
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        break;
      case 'confirmed':
        statusColor = Colors.teal;
        statusIcon = Icons.thumb_up;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            status.toUpperCase(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusDescription(status),
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return "Your order has been successfully delivered.";
      case 'cancelled':
        return "This order has been cancelled.";
      case 'processing':
        return "Your order is being prepared.";
      case 'confirmed':
        return "Your order has been confirmed and will be processed soon.";
      default:
        return "Your order is pending confirmation.";
    }
  }
}

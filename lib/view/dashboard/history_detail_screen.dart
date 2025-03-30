import 'package:flutter/material.dart';
import 'package:folder_structure/model/order_history.dart';

class HistoryDetailScreen extends StatelessWidget {
  final OrderHistory order;

  const HistoryDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderDetailCard(
                Icons.receipt, 'Order ID', order.orderId ?? ""),
            _buildOrderDetailCard(
                Icons.timelapse, 'Order Status', order.orderStatus ?? 'Pending',
                color: Colors.green),
            _buildOrderDetailCard(
                Icons.payment, 'Payment Method', order.payment?.method ?? 'N/A',
                color: Colors.orange),
            _buildOrderDetailCard(
                Icons.fastfood,
                'Items',
                order.items?.map((item) => item.foodName).join(', ') ??
                    'No items',
                color: Colors.purple),
            _buildOrderDetailCard(Icons.attach_money, 'Total Price',
                '\RS ${order.totalAmount ?? '0'}',
                color: Colors.teal),
            const SizedBox(height: 20),
            _buildSectionTitle('Payment Status'),
            _buildDetailText(order.orderStatus ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailCard(IconData icon, String title, String value,
      {Color color = Colors.blue}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

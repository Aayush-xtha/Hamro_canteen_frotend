// import 'package:flutter/material.dart';
// import 'package:folder_structure/controller/dashboard/cart_controller.dart';
// import 'package:folder_structure/utils/color.dart';
// import 'package:folder_structure/utils/custom_snackbar.dart';
// import 'package:get/get.dart';

// class CheckoutScreen extends StatelessWidget {
//   final AddToCartController cartController = Get.find<AddToCartController>();

//   CheckoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout"),
//         backgroundColor: AppColors.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (cartController.isCartEmpty) {
//           return const Center(
//             child: Text(
//               "Your cart is empty",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           );
//         }
        
//         final selectedItems = cartController.allCartItems
//             .where((item) => cartController.selectedItems.contains(item.cartId))
//             .toList();

//         if (selectedItems.isEmpty) {
//           return const Center(
//             child: Text(
//               "No items selected for checkout",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: selectedItems.length,
//                   itemBuilder: (context, index) {
//                     final item = selectedItems[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: item.foodImage != null
//                               ? Image.network(item.foodImage!, width: 50, height: 50, fit: BoxFit.cover)
//                               : const Icon(Icons.fastfood),
//                         ),
//                         title: Text(item.foodName ?? "Food Item"),
//                         subtitle: Text(
//                           "Qty: ${item.quantity} • Unit Price: ₹${item.unitPrice}",
//                         ),
//                         trailing: Text(
//                           "₹${(double.tryParse(item.unitPrice ?? '0') ?? 0) * (int.tryParse(item.quantity ?? '0') ?? 0)}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Total Amount",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "₹${cartController.selectedTotal.toStringAsFixed(2)}",
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColor,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 54),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (cartController.selectedItems.isEmpty) {
//                     CustomSnackBar.error(title: "Checkout", message: "Please select items to checkout");
//                   } else {
//                     // You can implement the checkout logic here
//                     CustomSnackBar.success(title: "Checkout", message: "Checkout successful!");
//                     cartController.removeSelectedItems();
//                     Get.back(); // Go back after checkout
//                   }
//                 },
//                 child: const Text(
//                   "Place Order",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

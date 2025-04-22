import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/repo/get_order_history.dart';
import 'package:folder_structure/repo/payment_status_repo.dart';
import 'package:folder_structure/repo/staff_order_confirmation_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class StaffConfirmationController extends GetxController {
  @override
  void onInit() {
    filterOrderdDetails();
    super.onInit();
  }

  RxList<OrderHistory> allOrderHistory = <OrderHistory>[].obs;
  RxBool loadings = RxBool(false);

  filterOrderdDetails() async {
    loadings.value = true;

    await GetOrderRepo.getOrderRepo(
      onSuccess: (pay) {
        loadings.value = false;
        final paymentMethod = pay
            .where(
              (p) =>
                  p.payment?.method?.toLowerCase() == 'cash' ||
                  p.orderStatus?.toLowerCase() == "pending",
            )
            .toList();

        paymentMethod.sort((a, b) {
          final dateA = DateTime.tryParse(a.orderDate ?? '') ?? DateTime.now();
          final dateB = DateTime.tryParse(b.orderDate ?? '') ?? DateTime.now();
          return dateB.compareTo(dateA);
        });

        allOrderHistory.assignAll(paymentMethod);
      },
      onError: (message) {
        loadings.value = false;
        CustomSnackBar.error(title: "order", message: message);
      },
    );
  }

  final loading = SimpleFontelicoProgressDialog(
      context: Get.context!, barrierDimisable: false);
  void confirmOrder(String orderId, String paymentAmount) async {
    loading.show(message: "Please wait..");

    await StaffOrderConfirmationRepo.staffOrderConfirmationRepo(
      orderId: orderId,
      paymentAmount: paymentAmount,
      onSuccess: () {
        loading.hide();

        // Remove the confirmed order from the list
        // allOrderHistory.removeWhere((order) => order.orderId == orderId);
        allOrderHistory.clear();
        filterOrderdDetails();
        CustomSnackBar.success(
            title: "Order", message: "Order confirmed successfully");
      },
      onError: (message) {
        loading.hide();
        CustomSnackBar.error(title: "Order", message: message);
      },
    );
  }

  void changePaymentStatus(String paymentId) async {
    loading.show(message: "Please wait..");

    await PaymentStatusRepo.paymentStatusRepo(
      paymentId: paymentId,
      onSuccess: () {
        loading.hide();

        // Remove the confirmed order from the list
        // allOrderHistory.removeWhere((order) => order.orderId == orderId);
        allOrderHistory.clear();
        filterOrderdDetails();
        CustomSnackBar.success(
            title: "Payment", message: "Payment confirmed successfully");
      },
      onError: (message) {
        loading.hide();
        CustomSnackBar.error(title: "Payment", message: message);
      },
    );
  }
}

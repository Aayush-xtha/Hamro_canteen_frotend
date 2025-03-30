import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/repo/get_order_history.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:get/get.dart';

class HistoryScreenController extends GetxController {
  @override
  void onInit() {
    getAllOrders();
    super.onInit();
  }

  RxList<OrderHistory> allOrderHistory = <OrderHistory>[].obs;
  RxBool loadings = RxBool(false);
  getAllOrders() async {
    loadings.value = true;
    await GetOrderRepo.getOrderRepo(onSuccess: (order) {
      loadings.value = false;
      allOrderHistory.addAll(order);
    }, onError: (message) {
      loadings.value = false;
      CustomSnackBar.error(title: "foods", message: message);
    });
  }
}

import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/repo/get_order_history.dart';
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
      // CustomSnackBar.error(title: "foods", message: message);
    });
  }

  filterOrderdDetails() async {
    loadings.value = true;
    await GetOrderRepo.getOrderRepo(
      onSuccess: (order) {
        loadings.value = false;

        // ✅ Filter only pending orders here
        final pendingOrders = order
            .where(
              (o) => o.orderStatus?.toLowerCase() == 'pending',
            )
            .toList();

        allOrderHistory.assignAll(pendingOrders);
      },
      onError: (message) {
        loadings.value = false;
        // CustomSnackBar.error(title: "foods", message: message);
      },
    );
  }
}

import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/repo/add_order_repo.dart';
import 'package:folder_structure/repo/get_food_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:folder_structure/view/dash_screen.dart';
import 'package:get/get.dart';

class MenuListController extends GetxController {
  void getFood(String value) {}
  @override
  void onInit() {
    getAllFoods();
    super.onInit();
  }

  RxList<FoodDetails> allFoods = <FoodDetails>[].obs;
  RxBool loadings = RxBool(false);
  final selectedPayment = "".obs;
  void updateSeletedPayment(String payment) {
    selectedPayment.value = payment;
  }

  getAllFoods() async {
    {}
    loadings.value = true;
    await GetFoodRepo.getFoodRepo(onSuccess: (food) {
      loadings.value = false;
      allFoods.addAll(food);
    }, onError: (message) {
      loadings.value = false;
      CustomSnackBar.error(title: "foods", message: message);
    });
  }

  addOrders(String foodId, String userId, String paymentMethod, String quantity,
      String rate) async {
    loadings.value = true;
    await AddOrderRepo.orderRepo(
      
        userid: userId,
        foodItems: [
          {"food_id": foodId, "quantity": quantity, "rate": rate}
        ],
        paymentMethod: paymentMethod,
        onSuccess: () {
          CustomSnackBar.success(
              title: "Order Successful", message: "Order placed successfully");
          Get.offAll(() => DashScreen());
        },
        onError: (message) {
          loadings.value = false;
          CustomSnackBar.error(message: message, title: "Order Error");
        });
  }

  //  addToCart(String foodId, String userId, String paymentMethod, String quantity,
  //     String rate) async {
  //   loadings.value = true;
  //   await AddOrderRepo.orderRepo(
      
  //       userid: userId,
  //       foodItems: [
  //         {"food_id": foodId, "quantity": quantity, "rate": rate}
  //       ],
  //       paymentMethod: paymentMethod,
  //       onSuccess: () {
  //         CustomSnackBar.success(
  //             title: "Order Successful", message: "Order placed successfully");
  //       },
  //       onError: (message) {
  //         loadings.value = false;
  //         CustomSnackBar.error(message: message, title: "Order Error");
  //       });
  // }
}

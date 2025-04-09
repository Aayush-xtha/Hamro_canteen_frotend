// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:folder_structure/constant/esewa.dart';
import 'package:folder_structure/controller/dashboard/menu_list_controller.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';

class Esewa {
  final c = Get.put(MenuListController());
  pay(String foodId, String userId, String paymentMethod, String quantity,
      String rate) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: "20",
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint(":::SUCCESS::: => $data");
          // verifyTransactionStatus(data);
          c.addOrders(foodId, userId, paymentMethod, quantity, rate);
        },
        onPaymentFailure: (data) {
          debugPrint(":::FAILURE::: => $data");
          CustomSnackBar.error(title: "Payment", message: "Payment Failure");
        },
        onPaymentCancellation: (data) {
          debugPrint(":::CANCELLATION::: => $data");
          CustomSnackBar.info(title: "Payment", message: "Payment Cancel");
        },
      );
    } on Exception catch (e) {
      debugPrint("EXCEPTION : ${e.toString()}");
    }
  }

  void verifyTransactionStatus(EsewaPaymentSuccessResult result) async {}
}

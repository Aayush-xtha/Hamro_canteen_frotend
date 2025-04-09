import 'package:folder_structure/model/notification.dart';
import 'package:get/get.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/repo/get_notification_repo.dart';

class NotificationController extends GetxController {
  RxList<GetNotification> notifications = <GetNotification>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  void getNotifications() async {
    final coreController = Get.find<CoreController>();
    final userId = coreController.currentUser.value?.id;
    final branchId = coreController.currentUser.value?.branchId;

    if (userId != null && branchId != null) {
      isLoading.value = true;
      await GetNotificationRepo.getNotificationRepo(
        userId: userId.toString(),
        branchId: branchId.toString(),
        onSuccess: (data) {
          notifications.value = data;
          isLoading.value = false;
        },
        onError: (message) {
          isLoading.value = false;
          print("Error fetching notifications: $message");
        },
      );
    } else {
      print("User ID or Branch ID is null");
    }
  }
}

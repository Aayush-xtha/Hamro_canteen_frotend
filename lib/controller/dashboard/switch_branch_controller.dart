import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/branch.dart';
import 'package:folder_structure/repo/get_branch_repo.dart';
import 'package:folder_structure/repo/switch_branch_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';

import 'package:get/get.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class SwitchBranchController extends GetxController {
  final coreController = Get.find<CoreController>();
  Rx<BranchDetail?> selectedBranch = Rx<BranchDetail?>(null);
  RxList<BranchDetail> allBranches = <BranchDetail>[].obs;

  @override
  void onInit() {
    fetchBranches();
    super.onInit();
  }

  void fetchBranches() {
    GetBranchRepo.getBranchRepo(
      onSuccess: (branches) {
        allBranches.assignAll(branches);
        if (branches.isNotEmpty) {
          selectedBranch.value = branches.first;
        }
      },
      onError: (message) {
        print("Error fetching branches: $message");
      },
    );
  }

  void onSelectBranch(BranchDetail branch) {
    selectedBranch.value = branch;
  }

  final loading = SimpleFontelicoProgressDialog(
      context: Get.context!, barrierDimisable: false);

  void onSwitchBranch() async {
    if (selectedBranch.value != null) {
      loading.show(message: "Please wait...");
      await SwitchBranchRepo.switchBranchRepo(
          branchId: selectedBranch.value!.branchId ?? "",
          onSuccess: () {
            loading.hide();

            CustomSnackBar.success(
                title: "Branch", message: "Branch switch successfully");
            coreController.logOut();
          },
          onError: (message) {
            loading.hide();
            CustomSnackBar.error(title: "Branch", message: message);
          });
    }
  }
}

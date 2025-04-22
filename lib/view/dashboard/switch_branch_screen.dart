import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/switch_branch_controller.dart';
import 'package:folder_structure/model/branch.dart';
import 'package:get/get.dart';

class SwitchBranchScreen extends StatelessWidget {
  final controller = Get.put(SwitchBranchController());

  SwitchBranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Switch Branch")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Select the branch"),
                const SizedBox(height: 16),
                DropdownButtonFormField<BranchDetail>(
                  value: controller.selectedBranch.value,
                  items: controller.allBranches
                      .map((branch) => DropdownMenuItem(
                            value: branch,
                            child: Text(branch.branchName ?? ""),
                          ))
                      .toList(),
                  onChanged: (branch) {
                    if (branch != null) {
                      controller.onSelectBranch(branch);
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.onSwitchBranch,
                  child: const Text("Switch"),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

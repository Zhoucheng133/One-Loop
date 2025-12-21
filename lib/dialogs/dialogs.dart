import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';

void showErrOkDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('ok'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> showConfirmDialog(BuildContext context, String title, String content, {String okText='ok'}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () {
              Navigator.of(context).pop(false);
            }
          ),
          TextButton(
            child: Text(okText.tr),
            onPressed: () {
              Navigator.of(context).pop(true);
            }
          ),
        ]
      );
    }
  );
}

Future<void> showRenameDialog(BuildContext context, String oldName) async {

  final nameController=TextEditingController();

  final controller = Get.find<Controller>();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('rename'.tr),
        content: StatefulBuilder(
          builder: (context, setState)=> TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: oldName
            ),
            controller: nameController,
          )
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          ElevatedButton(
            child: Text('ok'.tr),
            onPressed: () {
              final index=controller.audioList.indexWhere((element) => element.name == nameController.text);
              if (nameController.text.isEmpty) {
                showErrOkDialog(context, "addFailed".tr, 'emptyName'.tr);
                return;
              }else if(index!=-1){
                showErrOkDialog(context, "addFailed".tr, 'duplicateName'.tr);
                return;
              }
              controller.rename(oldName, nameController.text);
              Navigator.of(context).pop();
            }
          )
        ]
      );
    }
  );
}
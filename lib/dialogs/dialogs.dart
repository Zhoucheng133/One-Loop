import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

Future<bool?> showConfirmDialog(BuildContext context, String title, String content) async {
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
            child: Text('ok'.tr),
            onPressed: () {
              Navigator.of(context).pop(true);
            }
          ),
        ]
      );
    }
  );
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/dialogs/dialogs.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  final controller = Get.find<Controller>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('language'.tr),
          leading: Icon(Icons.language_rounded),
          onTap: () => showLanguageDialog(context)
        ),
        ListTile(
          title: Text('reset'.tr),
          leading: Icon(Icons.replay_rounded),
          onTap: () async {
            bool? result = await showConfirmDialog(context, 'reset'.tr, 'resetContent'.tr);
            if(result??false){
              controller.reset();
            }
          },
        ),
        ListTile(
          title: Text('about'.tr),
          leading: Icon(Icons.info_rounded),
          onTap: ()=>showAbout(context),
        ),
      ],
    );
  }
}
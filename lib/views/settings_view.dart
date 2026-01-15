import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/dialogs/dialogs.dart';
import 'package:one_loop/views/local_view.dart';

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
      padding: EdgeInsets.zero,
      children: [
        FTileGroup(
          label: Text('appSettings'.tr),
          children: [
            FTile(
              title: Text('language'.tr),
              prefix: Icon(Icons.language_rounded),
              onPress: () => showLanguageDialog(context)
            ),
            FTile(
              title: Text('reset'.tr),
              prefix: Icon(Icons.replay_rounded),
              onPress: () async {
                bool? result = await showConfirmDialog(context, 'reset'.tr, 'resetContent'.tr);
                if(result??false){
                  controller.reset();
                }
              },
            ),
          ],
        ),
        FTileGroup(
          label: Text('others'.tr),
          children: [
            FTile(
              title: Text("localFiles".tr),
              prefix: Icon(Icons.folder_open_rounded),
              onPress: () => Get.to(() => LocalView()),
            ),
            FTile(
              title: Text('about'.tr),
              prefix: Icon(Icons.info_rounded),
              onPress: ()=>showAbout(context),
            ),
          ],
        ),
      ],
    );
  }
}
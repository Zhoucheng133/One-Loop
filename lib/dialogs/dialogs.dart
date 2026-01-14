import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

void showLanguageDialog(BuildContext context) async { 
  final controller = Get.find<Controller>();

  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text("language".tr),
      content: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: controller.lang.value.name,
          items: supportedLocales.map((item)=>DropdownMenuItem<String>(
            value: item.name,
            child: Text(
              item.name
            ),
          )).toList(),
          onChanged: (val){
            final index=supportedLocales.indexWhere((element) => element.name==val);
            controller.changeLanguage(index);
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('ok'.tr),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

}

Future<void> showAbout(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if(context.mounted){
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('about'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
            ),
            const SizedBox(height: 10,),
            Text(
              'One Loop',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              'v${packageInfo.version}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                final url=Uri.parse('https://github.com/Zhoucheng133/One-Loop');
                launchUrl(url);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'projUrl'.tr,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: ()=>showLicensePage(
                applicationName: 'One Loop',
                applicationVersion: 'v${packageInfo.version}',
                context: context
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        "license".tr,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      ),
    );
  }
}
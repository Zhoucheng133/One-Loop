import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void showErrOkDialog(BuildContext context, String title, String content) {
  showFDialog(
    context: context,
    builder: (context, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        direction: Axis.horizontal,
        title: Text(title, style: TextStyle(fontFamily: "PuHui")),
        body: Text(content, style: TextStyle(fontFamily: "PuHui")),
        actions: [
          FButton.raw(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Text(
                'ok'.tr,
                style: TextStyle(
                  fontFamily: "PuHui",
                  color: Colors.white
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ),
            onPress: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
  );
}

Future<bool?> showConfirmDialog(BuildContext context, String title, String content, {String okText='ok'}) async {
  return await showFDialog(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style.call,
      animation: animation,
      direction: Axis.horizontal,
        title: Text(title, style: TextStyle(fontFamily: "PuHui"),),
        body: Text(content, style: TextStyle(fontFamily: "PuHui"),),
        actions: [
          FButton.raw(
            style: FButtonStyle.outline(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  fontFamily: "PuHui",
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ),
            onPress: () {
              Navigator.of(context).pop(false);
            }
          ),
          FButton.raw(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Text(
                okText.tr,
                style: TextStyle(
                  fontFamily: "PuHui",
                  color: Colors.white
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ),
            onPress: () {
              Navigator.of(context).pop(true);
            }
          ),
        ]
      )
  );
}

Future<void> showRenameDialog(BuildContext context, String oldName) async {

  final nameController=TextEditingController();

  final controller = Get.find<Controller>();

  await showFDialog(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style.call,
      animation: animation,
      direction: Axis.horizontal,
      title: Text('rename'.tr, style: TextStyle(fontFamily: "PuHui"),),
      body: StatefulBuilder(
        builder: (context, setState)=> FTextField(
          autofocus: true,
          hint: oldName,
          // controller: nameController,
          control: FTextFieldControl.managed(
            controller: nameController
          ),
        )
      ),
      actions: [
        FButton.raw(
          style: FButtonStyle.outline(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                fontFamily: "PuHui"
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
          onPress: () {
            Navigator.of(context).pop();
          }
        ),
        FButton.raw(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Text(
              'ok'.tr,
              style: TextStyle(
                fontFamily: "PuHui",
                color: Colors.white
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
          onPress: () {
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
    )
  );
}

void showLanguageDialog(BuildContext context) async { 
  final controller = Get.find<Controller>();

  showFDialog(
    context: context, 
    builder: (context, style, animation) => FDialog(
      style: style.call,
      animation: animation,
      direction: Axis.horizontal,
      title: Text("language".tr),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FSelect<Locale>.rich(
          format: (s){
            return supportedLocales.firstWhere((element) => element.locale == s).name;
          },
          control: FSelectControl.lifted(
            value: controller.lang.value.locale, 
            onChange: (Locale? val){
              if(val!=null){
                int index=supportedLocales.indexWhere((element) => element.locale == val);
                controller.changeLanguage(index);
              }
            }
          ), 
          children: supportedLocales.map((e) => FSelectItem(
            value: e.locale,
            title: Text(e.name),
          )).toList(),
        ),
      ),
      actions: [
        FButton.raw(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            child: Text(
              'ok'.tr,
              style: TextStyle(
                fontFamily: "PuHui",
                color: Colors.white
              ),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
          onPress: (){
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
    showFDialog(
      context: context, 
      builder: (context, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        direction: Axis.horizontal,
        title: Text('about'.tr, style: TextStyle(fontFamily: "PuHui"),),
        body: Column(
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
                fontFamily: "PuHui"
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              'v${packageInfo.version}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
                fontFamily: "PuHui"
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
                          fontFamily: "PuHui",
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
                        fontFamily: "PuHui"
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
            }, 
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Text(
                'ok'.tr,
                style: TextStyle(
                  fontFamily: "PuHui",
                  color: Colors.white
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
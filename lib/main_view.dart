import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/views/add_view.dart';
import 'package:one_loop/views/home_view.dart';
import 'package:one_loop/views/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      FScaffold(
        header: FHeader(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(controller.currentPage.value.name.tr),
          ),
          suffixes: [
            FHeaderAction(icon: const Icon(FIcons.plus), onPress: () {
              Get.to(()=>AddView());
            }),
            const SizedBox(width: 10.0,)
          ],
        ),
        resizeToAvoidBottomInset: false,
        footer: FBottomNavigationBar(
          index: controller.currentPage.value.index,
          onChange: (int index){
            controller.currentPage.value=Pages.values[index];
          },
          children: [
            FBottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: Text('home'.tr),
            ),
            FBottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: Text('settings'.tr),
            ),
          ],
        ),
        child: IndexedStack(
          index: controller.currentPage.value==Pages.settings ? 1 : 0,
          children: [
            HomeView(),
            SettingsView()
          ],
        )
      )
    );
  }
}
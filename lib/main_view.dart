import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/controller.dart';
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
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(controller.currentPage.value.name.tr),
          scrolledUnderElevation: 0.0,
        ),
        body: IndexedStack(
          index: controller.currentPage.value==Pages.settings ? 1 : 0,
          children: [
            HomeView(),
            SettingsView()
          ],
        ),
        floatingActionButton: controller.currentPage.value==Pages.home ? FloatingActionButton(
          onPressed: () {
            // TODO 添加
          },
          child: Icon(Icons.add_rounded),
        ) : null,
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              label: 'settings'.tr,
            ),
          ],
          onDestinationSelected: (index) {
            controller.currentPage.value = index==0 ? Pages.home : Pages.settings;
          },
          selectedIndex: controller.currentPage.value==Pages.settings ? 1 : 0
        )
      )
    );
  }
}
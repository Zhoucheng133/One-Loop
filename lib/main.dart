import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/audio.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/lang/en_us.dart';
import 'package:one_loop/lang/zh_cn.dart';
import 'package:one_loop/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final controller=Get.put(Controller());
  controller.init();
  runApp(const MainApp());
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
  };
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final controller = Get.find<Controller>();
  final Audio audio=Audio();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return GetMaterialApp(
      translations: MainTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      theme: ThemeData(
        brightness: brightness,
        fontFamily: 'PuHui', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          brightness: brightness,
        ),
        textTheme: brightness==Brightness.dark ? ThemeData.dark().textTheme.apply(
          fontFamily: 'PuHui',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ) : ThemeData.light().textTheme.apply(
          fontFamily: 'PuHui',
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainView()
    );
  }
}

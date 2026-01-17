import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:one_loop/controllers/audio.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:one_loop/lang/en_us.dart';
import 'package:one_loop/lang/zh_cn.dart';
import 'package:one_loop/lang/zh_tw.dart';
import 'package:one_loop/main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final controller=Get.put(Controller());
  final audio=Get.put(Audio());
  await controller.init();
  await audio.init();
  runApp(const MainApp());
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
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
    return Obx(
      () => GetMaterialApp(
        translations: MainTranslations(),
        locale: controller.lang.value.locale,
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
        theme: brightness==Brightness.dark ? FThemes.violet.dark.toApproximateMaterialTheme() : FThemes.violet.light.toApproximateMaterialTheme(),
        builder: (_, child) => FAnimatedTheme(
          data: brightness==Brightness.dark ? FThemes.violet.dark : FThemes.violet.light,
          child: DefaultTextHeightBehavior(
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            child: FToaster(child: child!)
          )
        ),
        debugShowCheckedModeBanner: false,
        home: MainView()
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class LanguageType{
  String name;
  Locale locale;

  LanguageType(this.name, this.locale);
}

List<LanguageType> get supportedLocales => [
  LanguageType("English", Locale("en", "US")),
  LanguageType("简体中文", Locale("zh", "CN")),
  LanguageType("繁體中文", Locale("zh", "TW")),
];

enum Pages{
  home,
  settings,
}

enum AudioType{
  file,
  network
}

class AudioItem{
  String name;
  // 如果是文件，存储文件名，如果是网络，存储网络地址
  String path;
  AudioType type;
  AudioItem({required this.name, required this.path, required this.type});

  factory AudioItem.fromJson(Map<String, dynamic> json) {
    return AudioItem(
      name: json['name'],
      path: json['path'],
      type: AudioType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type.index,
    };
  }
}

class Controller extends GetxController {
  RxList<AudioItem> audioList = RxList<AudioItem>([]);
  Rx<LanguageType> lang=Rx(supportedLocales[0]);
  Rx<Pages> currentPage=Rx(Pages.home);

  late SharedPreferences prefs;

  void addAudio(AudioItem audio){
    audioList.add(audio);
    prefs.setStringList("audioList", audioList.map((e) => jsonEncode(e.toJson())).toList());
  }

  void removeAudio(AudioItem audio){
    audioList.removeWhere((element) => element.name==audio.name);
    if(audio.type==AudioType.file){
      File(audio.path).delete();
    }
    prefs.setStringList("audioList", audioList.map((e) => jsonEncode(e.toJson())).toList());
  }

  void rename(String oldName, String newName){
    audioList.firstWhere((element) => element.name==oldName).name=newName;
    audioList.refresh();
    prefs.setStringList("audioList", audioList.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> reset() async {
    audioList.clear();
    prefs.clear();
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(appDir.path, 'audioFiles'));

    if (await audioDir.exists()) {
      await audioDir.delete(recursive: true);
    }
  }

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();

    int? langIndex=prefs.getInt("langIndex");

    if(langIndex==null){
      final deviceLocale=PlatformDispatcher.instance.locale;
      final local=Locale(deviceLocale.languageCode, deviceLocale.countryCode);
      int index=supportedLocales.indexWhere((element) => element.locale==local);
      if(index!=-1){
        lang.value=supportedLocales[index];
        lang.refresh();
      }
    }else{
      lang.value=supportedLocales[langIndex];
    }

    audioList.value=prefs.getStringList("audioList")?.map((e) => AudioItem.fromJson(jsonDecode(e))).toList() ?? [];
  }
  
  void changeLanguage(int index){
    lang.value=supportedLocales[index];
    prefs.setInt("langIndex", index);
    lang.refresh();
    Get.updateLocale(lang.value.locale);
  }
}
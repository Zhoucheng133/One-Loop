import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_loop/controllers/controller.dart';

class Audio extends GetxController {

  final AudioPlayer player = AudioPlayer();
  final controller = Get.find<Controller>();

  init() async {
    await player.setLoopMode(LoopMode.one);
  }

  Audio() {
    init();
  }

  void play() async {
    
  }

  void pause() async {
    
  }
}
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Audio extends GetxController {

  late AudioPlayer player;

  RxDouble percent = 0.0.obs;
  RxInt milliseconds = 0.obs;
  Future<void> init() async {
    player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
  }

  Future<void> setItem(AudioItem item) async {
    if(item.type==AudioType.file){
      final appDir = await getApplicationDocumentsDirectory();
      final audioPath = p.join(appDir.path, 'audioFiles', item.path);
      await player.setFilePath(audioPath);
    }else{
      await player.setUrl(item.path);
    }
    if(player.duration!=null){
      milliseconds.value=player.duration!.inMilliseconds;
      player.positionStream.listen((position) {
        percent.value=position.inMilliseconds/player.duration!.inMilliseconds;
      });
    }
  }

  void play() async {
    player.play();
  }

  void pause() async {
    player.pause();
  }

  @override
  void dispose() async {
    super.dispose();
    player.stop();
    player.dispose();
  }
}
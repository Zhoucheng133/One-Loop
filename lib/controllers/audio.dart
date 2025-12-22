import 'package:just_audio/just_audio.dart';
import 'package:one_loop/controllers/controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Audio {

  late AudioPlayer player;

  void init(AudioItem item) async {
    player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
    if(item.type==AudioType.file){
      final appDir = await getApplicationDocumentsDirectory();
      final audioPath = p.join(appDir.path, 'audioFiles', item.path);
      await player.setFilePath(audioPath);
    }else{
      await player.setUrl(item.path);
    }
  }

  void play() async {
    player.play();
  }

  void pause() async {
    player.pause();
  }

  void dispose() async {
    player.stop();
    player.dispose();
  }
}
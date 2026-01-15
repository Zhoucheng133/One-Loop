import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalView extends StatefulWidget {
  const LocalView({super.key});

  @override
  State<LocalView> createState() => _LocalViewState();
}

class _LocalViewState extends State<LocalView> {

  List<File> ls=[];

  void getFiles() async {
    try {
      final Directory appDocDir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'audioFiles'));
      List<FileSystemEntity> entities = await appDocDir.list(recursive: true).toList();
      setState(() {
        ls = entities.whereType<File>().toList();
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(
            onPress: () => Get.back(),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('localFiles'.tr),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: ls.length,
        itemBuilder: (BuildContext context, int index)=>Text(
          p.basename(ls[index].path),
          style: TextStyle(
            fontFamily: 'PuHui',
          ),
        ),
      )
    );
  }
}
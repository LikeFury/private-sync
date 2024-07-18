import 'dart:io';

import 'package:private_sync/models/sync_file_model.dart';

class LocalDirectory {
  String path;
  List<SyncFileModel> files = [];
  DateTime lastestFileTime = DateTime(1900);

  LocalDirectory(this.path);

  Future<void> parseDirectory() async {
    final dir = Directory(path);
    final List<FileSystemEntity> entities =
        await dir.list(recursive: true).toList();

    await Future.forEach(entities, (FileSystemEntity entity) async {
      if (await FileSystemEntity.isFile(entity.path)) {
        final stat = await entity.stat();

        if (stat.modified.isAfter(lastestFileTime)) {
          lastestFileTime = stat.modified;
        }

        files.add(SyncFileModel(entity.path, stat.modified));
      }
    });

    return;
  }
}

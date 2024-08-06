import 'dart:io';

import 'package:private_sync/models/sync_directory_model.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/os.dart';

class LocalDirectory {
  late String path;
  List<SyncFileModel> files = [];
  List<SyncDirectoryModel> directories = [];

  DateTime lastestFileTime = DateTime(1900);

  LocalDirectory(String path) {
    this.path = path.replaceAll('~', Os().getHomeDirectory());

    var lastPathChar = this.path.substring(this.path.length - 1);
    if (lastPathChar != '/') {
      this.path = "${this.path}/";
    }
  }

  Future<void> parseDirectory() async {
    final dir = Directory(path);
    final List<FileSystemEntity> entities = await dir.list(recursive: true).toList();

    await Future.forEach(entities, (FileSystemEntity entity) async {
      if (await FileSystemEntity.isFile(entity.path)) {
        final stat = await entity.stat();

        if (stat.modified.isAfter(lastestFileTime)) {
          lastestFileTime = stat.modified;
        }

        files.add(SyncFileModel(entity.path, stat.modified));
      } else if (entity is Directory) {
        directories.add(SyncDirectoryModel(entity.path));
      }
    });

    return;
  }
}

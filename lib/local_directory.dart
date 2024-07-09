import 'dart:io';

class LocalDirectory {
  String path;

  List<File> files = [];

  LocalDirectory(this.path);

  Future<List<File>> parseDirectory() async {
    final dir = Directory(path);
    final List<FileSystemEntity> entities =
        await dir.list(recursive: true).toList();

    entities.forEach((FileSystemEntity entity) async {
      if (FileSystemEntity.isFileSync(entity.path)) {
        print(entity);
        final stat = await entity.stat();
        files.add(File(entity.path, stat.modified.millisecondsSinceEpoch));
        print(files.length);
      }

      /*print(entity);
      final stat = await entity.stat();
      print(stat.modified.millisecondsSinceEpoch /
          Duration.millisecondsPerSecond);*/
    });

    //return;
    return files;
  }
}

class File {
  String path;
  int modifyTime;

  File(this.path, this.modifyTime);
}

import 'dart:io';
import 'package:private_sync/ssh.dart';

class RemoteDirectory {
  Ssh sshClient;

  String path;
  List<RemoteFile> files = [];
  DateTime lastestFileTime = DateTime(1900);

  RemoteDirectory(this.sshClient, this.path);

  Future<void> parseDirectory() async {
    List<RemoteFile> directoryListing = await sshClient.listDirectory(path);

    directoryListing.forEach((RemoteFile file) {
      if (file.modifyTime.isAfter(lastestFileTime)) {
        lastestFileTime = file.modifyTime;
      }
    });

    files = directoryListing;
  }
}

class RemoteFile {
  String path;
  DateTime modifyTime;

  RemoteFile(this.path, this.modifyTime);
}

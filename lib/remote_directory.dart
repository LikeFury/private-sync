import 'dart:io';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/ssh.dart';

class RemoteDirectory {
  Ssh sshClient;

  String path;
  List<SyncFileModel> files = [];
  DateTime lastestFileTime = DateTime(1900);

  RemoteDirectory(this.sshClient, this.path);

  Future<void> parseDirectory() async {
    List<SyncFileModel> directoryListing = await sshClient.listDirectory(path);

    directoryListing.forEach((SyncFileModel file) {
      if (file.modifyTime.isAfter(lastestFileTime)) {
        lastestFileTime = file.modifyTime;
      }
    });

    files = directoryListing;
  }
}

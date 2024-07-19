import 'dart:io';
import 'package:collection/collection.dart';

import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';

class Sync {
  Ssh ssh;

  Sync(this.ssh);

  /// Syncs the files to and from the local and remote directories based on modified timestamps
  Future<void> syncFiles(
      LocalDirectory localDirectory, RemoteDirectory remoteDirectory) async {
    List<SyncFileModel> remoteFiles = remoteDirectory.files;

    for (SyncFileModel file in localDirectory.files) {
      var strippedFilePath = file.path.substring(localDirectory.path.length);

      SyncFileModel? matchedFile = remoteFiles.firstWhereOrNull(
          (SyncFileModel remoteFile) =>
              remoteFile.path.substring(remoteDirectory.path.length) ==
              strippedFilePath);

      if (matchedFile != null &&
          matchedFile.modifyTime.difference(file.modifyTime).inSeconds < 2) {
        print('${file.path} is up to date');
        remoteFiles
            .removeWhere((SyncFileModel file) => file.path == matchedFile.path);
      } else {
        print('${file.path} not found on server, uploading...');
        await ssh.uploadFile(file, remoteDirectory.path + strippedFilePath);
      }
    }

    for (SyncFileModel file in remoteFiles) {
      print('${file.path} not found locally, downloading...');
      var strippedFilePath = file.path.substring(remoteDirectory.path.length);
      await ssh.downloadFile(file, localDirectory.path + strippedFilePath);
    }

    return;
  }
}

import 'package:collection/collection.dart';
import 'package:file/file.dart';

import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_directory_model.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';

class Sync {
  Ssh ssh;
  FileSystem fileSystem;

  Sync(this.ssh, this.fileSystem);

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

  /// Sync directories between remote and local
  Future<void> syncDirectories(
      LocalDirectory localDirectory, RemoteDirectory remoteDirectory) async {
    List<SyncDirectoryModel> remoteDirectories = remoteDirectory.directories;

    // Sorty by depth to ensure we create directories in the correct order
    remoteDirectories.sort((a, b) => a.depth.compareTo(b.depth));
    localDirectory.directories.sort((a, b) => a.depth.compareTo(b.depth));

    for (SyncDirectoryModel directory in localDirectory.directories) {
      var strippedPath = directory.path.substring(localDirectory.path.length);

      // Look for directories on remote
      SyncDirectoryModel? matchedDirectory = remoteDirectories.firstWhereOrNull(
          (SyncDirectoryModel directory) =>
              directory.path.substring(remoteDirectory.path.length) ==
              strippedPath);

      // Create a directory if it does not exist
      if (matchedDirectory == null) {
        String remotePath = remoteDirectory.path + strippedPath;
        print('Creating remote directory: $remotePath');
        await ssh.createDirectory(remotePath);
      } else {
        // Remove known directories from the remote list
        print('Remote directory exists: ${matchedDirectory.path}');
        remoteDirectories.removeWhere((SyncDirectoryModel remoteDirectory) =>
            remoteDirectory.path == matchedDirectory.path);
      }
    }

    // Iterate over the remaining remote directories and create local version.
    for (SyncDirectoryModel directory in remoteDirectories) {
      var strippedPath = directory.path.substring(remoteDirectory.path.length);

      print('Creating local directory: ${localDirectory.path + strippedPath}');
      fileSystem.directory(localDirectory.path + strippedPath).createSync();
    }
  }

  Future<void> checkRemoteStoreDirectory(String path) async {
    try {
      await ssh.statFile(path);
    } catch (e) {
      await ssh.createDirectory(path);
    }
  }
}

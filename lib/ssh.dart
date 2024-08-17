import 'dart:io';

import 'package:dartssh3/dartssh3.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/remote_directory_listing_model.dart';
import 'package:private_sync/models/sync_directory_model.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/os.dart';

class Ssh {
  ConfigModel config;

  Ssh({required this.config});

  late SSHClient client;
  late SftpClient sftpClient;

  Future<void> connect() async {
    client = SSHClient(
      await SSHSocket.connect(config.hostname, config.port),
      username: config.username,
      identities: [...SSHKeyPair.fromPem(await File('${Os().getHomeDirectory()}/.ssh/id_rsa').readAsString())],
      //onPasswordRequest: () => '<password>',
      //printDebug: (String? message) => print(message)
    );

    sftpClient = await client.sftp();
  }

  /// List Directory
  Future<RemoteDirectoryListingModel> listDirectory(String path, {int depth = 0}) async {
    List<SyncFileModel> files = [];
    List<SyncDirectoryModel> directories = [];

    var items = await sftpClient.listdir(path);

    for (final item in items) {
      if (item.attr.isFile) {
        int modifiedTimestamp = item.attr.modifyTime as int;
        files.add(
            SyncFileModel('$path${item.filename}', DateTime.fromMillisecondsSinceEpoch(modifiedTimestamp * 1000)));
      }
      if (item.attr.isDirectory && item.filename != '.' && item.filename != '..') {
        directories.add(SyncDirectoryModel('$path${item.filename}', depth: depth));

        RemoteDirectoryListingModel recursiveDirectory =
            await listDirectory('$path${item.filename}/', depth: depth + 1);

        files.insertAll(files.length, recursiveDirectory.files);

        directories.insertAll(directories.length, recursiveDirectory.directories);
      }
    }

    return RemoteDirectoryListingModel(files, directories);
  }

  /// Create directory
  Future<void> createDirectory(String path) async {
    await sftpClient.mkdir(path);
  }

  /// Delete directory
  Future<void> deleteDirectory(String path) async {
    await sftpClient.rmdir(path);
  }

  /// Upload a file to the SSH server
  Future<void> uploadFile(SyncFileModel localFile, String remotePath) async {
    final file = await sftpClient.open(remotePath,
        mode: SftpFileOpenMode.create | SftpFileOpenMode.truncate | SftpFileOpenMode.write);
    await file.write(File(localFile.path).openRead().cast()).done;

    print('$remotePath uploaded');

    await sftpClient.setStat(
        remotePath,
        SftpFileAttrs(
            modifyTime: localFile.modifyTime.millisecondsSinceEpoch ~/ 1000,
            accessTime: localFile.modifyTime.millisecondsSinceEpoch ~/ 1000));

    print('$remotePath modify time set');
  }

  /// Download a file from the SSH server
  Future<void> downloadFile(SyncFileModel remoteFile, String localPath) async {
    final file = await sftpClient.open(remoteFile.path);

    final localFile = File(localPath).openWrite();
    await localFile.addStream(file.read().cast());
    localFile.flush();
    localFile.close();

    File(localPath).setLastModified(remoteFile.modifyTime);

    print('$localPath downloaded');
  }

  /// Stat a file
  Future<SftpFileAttrs> statFile(String path) async {
    return sftpClient.stat(path);
  }

  /// Delete a file
  Future<void> deleteFile(String path) async {
    return await sftpClient.remove(path);
  }

  /// Close the SSH connection
  Future<void> close() async {
    sftpClient.close();
    client.close();
    await client.done;
  }
}

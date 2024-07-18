import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/remote_directory.dart';

class Ssh {
  String host;
  String username;
  int port;

  Ssh({required this.host, this.port = 22, required this.username});

  late SSHClient client;
  late SftpClient sftpClient;

  Future<void> connect() async {
    client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      identities: [
        ...SSHKeyPair.fromPem(
            await File(getHomeDirectory() + '/.ssh/id_rsa').readAsString())
      ],
      //onPasswordRequest: () => '<password>',
      //printDebug: (String? message) => print(message)
    );

    sftpClient = await client.sftp();
  }

  /**
   * List Directory
   */
  Future<List<SyncFileModel>> listDirectory(String path) async {
    List<SyncFileModel> files = [];

    var items = await sftpClient.listdir(path);

    for (final item in items) {
      if (item.attr.isFile) {
        int modifiedTimestamp = item.attr.modifyTime as int;

        files.add(SyncFileModel(path + '/' + item.filename,
            DateTime.fromMillisecondsSinceEpoch(modifiedTimestamp * 1000)));
      }
      if (item.attr.isDirectory &&
          item.filename != '.' &&
          item.filename != '..') {
        files.insertAll(
            files.length, await listDirectory(path + '/' + item.filename));
      }
    }

    return files;
  }

  /**
   * Upload a file to the SSH server
   */
  Future<void> uploadFile(SyncFileModel localFile, String remotePath) async {
    final file = await sftpClient.open(remotePath,
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

    print('opened');

    await file.write(File(localFile.path).openRead().cast());

    print(remotePath + ' uploaded');

    await sftpClient.setStat(
        remotePath,
        SftpFileAttrs(
            modifyTime: localFile.modifyTime.millisecondsSinceEpoch ~/ 1000,
            accessTime: localFile.modifyTime.millisecondsSinceEpoch ~/ 1000));

    print(remotePath + ' modify time set');
  }

  Future<SftpFileAttrs> statFile(String path) async {
    return sftpClient.stat(path);
  }

  Future<void> close() async {
    sftpClient.close();
    client.close();
    await client.done;
  }

  /**
   * Get the home directory from the environment
   */
  String getHomeDirectory() {
    String home = "";
    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME'] as String;
    } else if (Platform.isLinux) {
      home = envVars['HOME'] as String;
    } else if (Platform.isWindows) {
      home = envVars['UserProfile'] as String;
    }

    return home;
  }
}

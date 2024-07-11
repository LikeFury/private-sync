import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
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
            await File('/home/demoncore/.ssh/id_rsa').readAsString())
      ],
      //onPasswordRequest: () => '<password>',
      //printDebug: (String? message) => print(message)
    );

    sftpClient = await client.sftp();
  }

  Future<List<RemoteFile>> listDirectory(String path) async {
    List<RemoteFile> files = [];

    var items = await sftpClient.listdir(path);

    for (final item in items) {
      if (item.attr.isFile) {
        int modifiedTimestamp = item.attr.modifyTime as int;

        files.add(RemoteFile(path + '/' + item.filename,
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

  Future<void> writeFile() async {
    final file = await sftpClient.open('/root/sync/fiadmin1.png',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

    await file.write(
        File('/home/demoncore/Downloads/fiadmin1.png').openRead().cast());

    print('File written');

    await sftpClient.setStat('/root/sync/fiadmin1.png',
        SftpFileAttrs(modifyTime: 1520442603, accessTime: 1520442603));

    print('File attributes set');
  }

  Future<SftpFileAttrs> statFile(String path) async {
    return sftpClient.stat(path);
  }

  Future<void> close() async {
    sftpClient.close();
    client.close();
    await client.done;
  }
}

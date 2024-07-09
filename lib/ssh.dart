import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

class Ssh {
  String host;
  String username;
  int port;

  Ssh({required this.host, this.port = 22, required this.username});

  late SSHClient client;
  late SftpClient sftpClient;

  Future<void> connect() async {
    client = SSHClient(await SSHSocket.connect(host, port),
        username: username,
        identities: [
          ...SSHKeyPair.fromPem(
              await File('/home/demoncore/.ssh/id_rsa').readAsString())
        ],
        //onPasswordRequest: () => '<password>',
        printDebug: (String? message) => print(message));

    sftpClient = await client.sftp();
  }

  Future<void> list() async {
    final items = await sftpClient.listdir('/root/');
    for (final item in items) {
      print(item.attr.modifyTime);
    }
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

  Future<void> close() async {
    sftpClient.close();
    client.close();
    await client.done;
  }
}

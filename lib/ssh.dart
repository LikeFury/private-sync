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
    client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      identities: [
        ...SSHKeyPair.fromPem(
            await File('/home/tsarbomba/.ssh/id_rsa').readAsString())
      ],
      //onPasswordRequest: () => '<password>',
    );

    sftpClient = await client.sftp();
  }

  Future<void> list() async {
    final items = await sftpClient.listdir('/root/');
    for (final item in items) {
      print(item.longname);
    }
  }
}

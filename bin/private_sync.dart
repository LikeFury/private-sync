import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:private_sync/config_model.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';
import 'package:private_sync/sync.dart';

Future<void> main() async {
  print('Private Sync');

  var input = await File('config.json').readAsString();
  var map = jsonDecode(input);

  ConfigModel config = ConfigModel.fromMap(map);

  Ssh sshClient =
      Ssh(host: config.hostname, port: config.port, username: config.username);

  print("Connecting to " + config.hostname);

  await sshClient.connect();

  await Future.forEach(config.syncDirectorys, (directory) async {
    print("Syncing " + directory.name + " " + directory.localDirectory);

    var local = LocalDirectory(directory.localDirectory);
    await local.parseDirectory();

    print("Latest local change: " + local.lastestFileTime.toString());

    local.files.forEach((SyncFileModel file) {
      print(file.path);
    });

    print("Remote directory: " + config.remoteDirectory + '/' + directory.name);
    var remote = RemoteDirectory(
        sshClient, config.remoteDirectory + '/' + directory.name);
    await remote.parseDirectory();
    print("Remote last change: " + remote.lastestFileTime.toString());

    remote.files.forEach((file) {
      print(file.path + " " + file.modifyTime.toString());
    });

    if (!local.lastestFileTime.isAtSameMomentAs(remote.lastestFileTime)) {
      print("Sync needed");
      await Sync(sshClient).sync(local, remote);
    }
  });

  await sshClient.close();
}

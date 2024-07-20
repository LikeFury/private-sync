import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file/local.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_directory_model.dart';
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

  print("Connecting to ${config.hostname}");

  await sshClient.connect();

  await Future.forEach(config.syncDirectorys, (directory) async {
    print("Syncing ${directory.name} ${directory.localDirectory}");

    var local = LocalDirectory(directory.localDirectory);
    await local.parseDirectory();

    print("Latest local change: ${local.lastestFileTime}");

    /*local.files.forEach((file) {
      print(file.path + " " + file.modifyTime.toString());
    });*/

    print('Remote directory: ${config.remoteDirectory}/${directory.name}');

    var remote = RemoteDirectory(
        sshClient, '${config.remoteDirectory}/${directory.name}');
    await remote.parseDirectory();
    print("Remote last change: ${remote.lastestFileTime}");

    int diff =
        local.lastestFileTime.difference(remote.lastestFileTime).inSeconds;

    if (diff > 1 || diff < -1 || local.files.length != remote.files.length) {
      print("Sync needed");

      Sync sync = Sync(sshClient, LocalFileSystem());
      await sync.syncDirectories(local, remote);
      await sync.syncFiles(local, remote);
    } else {
      print("No sync needed");
    }
  });

  await sshClient.close();
}

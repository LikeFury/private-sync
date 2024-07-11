import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:private_sync/config_model.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';

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

    print("Remote directory: " + config.remoteDirectory + '/' + directory.name);
    var remote = RemoteDirectory(
        sshClient, config.remoteDirectory + '/' + directory.name);
    await remote.parseDirectory();
    print("Remote last change: " + remote.lastestFileTime.toString());

    if (local.lastestFileTime.isAfter(remote.lastestFileTime)) {
      print("Local is newer");
    } else {
      print("Remote is newer");
    }
  });

  await sshClient.close();
}

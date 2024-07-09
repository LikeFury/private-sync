import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:private_sync/config_model.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/ssh.dart';

Future<void> main() async {
  print('Private Sync');
  print('Running Sync');

  //var input = await File('config.json').readAsString();
  //var map = jsonDecode(input);

  //ConfigModel config = ConfigModel.fromMap(map);

/*  LocalDirectory local =
      LocalDirectory(config.syncDirectorys[0].localDirectory);

  await local.getDirectoryContents();
  */

  //inspect(config);

  /*final dir = Directory('/home/tsarbomba/');
  final List<FileSystemEntity> entities = await dir.list().toList();
  entities.forEach(print);*/

  /*var ssh = Ssh(host: config.hostname, username: config.username);
  await ssh.connect();
  await ssh.list();

  //await ssh.writeFile();

  await ssh.close();*/
}

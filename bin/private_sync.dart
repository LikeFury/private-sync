import 'package:args/command_runner.dart';
import 'package:private_sync/commands/directory_command.dart';
import 'package:private_sync/commands/server_command.dart';
import 'package:private_sync/commands/sync_command.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';

Future<void> main(List<String> args) async {
  Config config = Config();
  late ConfigModel configModel;

  if (config.exists()) {
    configModel = config.loadConfig();
  } else {
    print('No config file found, creating it now');
    configModel = ConfigModel(hostname: '', username: '', remoteDirectory: '');
    config.writeConfig(configModel);
  }

  CommandRunner("private-sync",
      "Private Sync: sync files between PCs via your SSH server")
    ..addCommand(ServerCommand(configModel))
    ..addCommand(DirectoryCommand(configModel))
    ..addCommand(SyncCommand(configModel))
    ..argParser.addFlag('verbose',
        abbr: 'v',
        defaultsTo: false,
        help: "Show detailed logs",
        negatable: false)
    ..run(args);

  //print(runner.);

  return;

  /*print('Private Sync');

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

  await sshClient.close();*/
}

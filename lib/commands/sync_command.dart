
import 'package:args/command_runner.dart';
import 'package:file/local.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/config_directory_model.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';
import 'package:private_sync/sync.dart';

class SyncCommand extends Command {
  @override
  final name = "sync";
  @override
  final description = "Perform a sync to the SSH server";

  ConfigModel config;

  SyncCommand(this.config);

  @override
  void run() async {
    print('Private Sync');

    ConfigModel config = Config().loadConfig();

    Ssh sshClient = Ssh(config: config);

    print("Connecting to ${config.hostname}");

    await sshClient.connect();

    Sync sync = Sync(sshClient, LocalFileSystem());

    await Future.forEach(config.syncDirectories,
        (ConfigDirectoryModel directory) async {
      print("Syncing ${directory.name} ${directory.localDirectory}");

      var local = LocalDirectory(directory.localDirectory);
      await local.parseDirectory();

      print("Latest local change: ${local.lastestFileTime}");

      print('Remote directory: ${config.remoteDirectory}/${directory.name}/');

      await sync.checkRemoteStoreDirectory(
          '${config.remoteDirectory}/${directory.name}');

      var remote = RemoteDirectory(
          sshClient, '${config.remoteDirectory}/${directory.name}/');
      await remote.parseDirectory();
      print("Remote last change: ${remote.lastestFileTime}");

      int diff =
          local.lastestFileTime.difference(remote.lastestFileTime).inSeconds;

      if (diff > 1 || diff < -1 || local.files.length != remote.files.length) {
        print("Sync needed");

        await sync.syncDirectories(local, remote);
        await sync.syncFiles(local, remote);
      } else {
        print("No sync needed");
      }
    });

    await sshClient.close();
  }
}

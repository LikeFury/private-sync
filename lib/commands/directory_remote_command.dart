import 'package:args/command_runner.dart';
import 'package:dartssh3/dartssh3.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/config_directory_model.dart';
import 'package:private_sync/models/remote_directory_listing_model.dart';
import 'package:private_sync/ssh.dart';

class DirectoryRemoteCommand extends Command {
  @override
  final name = "remote";
  @override
  final description = "List the synced directories on the server";

  ConfigModel config;

  DirectoryRemoteCommand(this.config);

  @override
  void run() async {
    Ssh sshClient = Ssh(config: config);
    print("Connecting to ${config.hostname}");

    await sshClient.connect();

    List<SftpName> directories = await sshClient.sftpClient.listdir('${config.remoteDirectory}/');

    print("Remote Directories:");
    for (final directory in directories) {
      if (directory.filename == '.' || directory.filename == '..') {
        continue;
      }
      print(directory.filename);
    }
    await sshClient.close();
  }
}

import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';

class ServerDirectoryCommand extends Command {
  @override
  final name = "directory";
  @override
  final description = "Set SSH directory to store all the files";

  ConfigModel config;

  ServerDirectoryCommand(this.config);

  @override
  void run() async {
    config.remoteDirectory = argResults!.rest[0];
    Config().writeConfig(config);
    print("SSH directory set to: ${config.remoteDirectory}");
  }
}

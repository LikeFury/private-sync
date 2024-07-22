import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';

class ServerUsernameCommand extends Command {
  @override
  final name = "username";
  @override
  final description = "Set SSH username";

  ConfigModel config;

  ServerUsernameCommand(this.config);

  @override
  void run() async {
    config.username = argResults!.rest[0];
    Config().writeConfig(config);
    print("Username set to: ${config.username}");
  }
}

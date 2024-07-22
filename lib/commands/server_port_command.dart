import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';

class ServerPortCommand extends Command {
  @override
  final name = "port";
  @override
  final description = "Set SSH port";

  ConfigModel config;

  ServerPortCommand(this.config);

  @override
  void run() async {
    try {
      config.port = int.parse(argResults!.rest[0]);
      Config().writeConfig(config);
      print("Port set to: ${config.port}");
    } catch (error) {
      print("Port must be a number!");
    }
  }
}

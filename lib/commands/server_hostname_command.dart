import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';

class ServerHostnameCommand extends Command {
  @override
  final name = "hostname";
  @override
  final description = "Set SSH hostname";

  ConfigModel config;

  ServerHostnameCommand(this.config);

  @override
  void run() async {
    config.hostname = argResults!.rest[0];
    Config().writeConfig(config);
    print("Hostname set to: ${config.hostname}");
  }
}

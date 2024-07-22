import 'package:args/command_runner.dart';
import 'package:private_sync/models/config_model.dart';

class ServerShowCommand extends Command {
  @override
  final name = "show";
  @override
  final description = "Show current SSH server configuration";

  ConfigModel config;

  ServerShowCommand(this.config);

  @override
  void run() async {
    print("Hostname: ${config.hostname}");
    print("Username: ${config.username}");
    print("Port: ${config.port}");
    print("Remote Directory: ${config.remoteDirectory}");
  }
}

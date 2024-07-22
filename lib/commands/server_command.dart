import 'package:args/command_runner.dart';

import 'package:private_sync/commands/server_directory_command.dart';
import 'package:private_sync/commands/server_hostname_command.dart';
import 'package:private_sync/commands/server_port_command.dart';
import 'package:private_sync/commands/server_show_command.dart';
import 'package:private_sync/commands/server_test_command.dart';
import 'package:private_sync/commands/server_username_command.dart';
import 'package:private_sync/models/config_model.dart';

class ServerCommand extends Command {
  @override
  final name = "server";
  @override
  final description = "Set the SSH server you wish to use";

  ConfigModel config;

  ServerCommand(this.config) {
    addSubcommand(ServerShowCommand(config));
    addSubcommand(ServerHostnameCommand(config));
    addSubcommand(ServerPortCommand(config));
    addSubcommand(ServerUsernameCommand(config));
    addSubcommand(ServerDirectoryCommand(config));
    addSubcommand(ServerTestCommand(config));
  }
}

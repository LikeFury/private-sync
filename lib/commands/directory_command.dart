import 'package:args/command_runner.dart';
import 'package:private_sync/commands/directory_add_command.dart';
import 'package:private_sync/commands/directory_remote_command.dart';
import 'package:private_sync/commands/directory_remove_command.dart';
import 'package:private_sync/commands/directory_show_command.dart';
import 'package:private_sync/models/config_model.dart';

class DirectoryCommand extends Command {
  @override
  final name = "directory";
  @override
  final description = "Setup directories you want to be synced";

  ConfigModel config;

  DirectoryCommand(this.config) {
    addSubcommand(DirectoryShowCommand(config));
    addSubcommand(DirectoryAddCommand(config));
    addSubcommand(DirectoryRemoveCommand(config));
    addSubcommand(DirectoryRemoteCommand(config));
  }
}

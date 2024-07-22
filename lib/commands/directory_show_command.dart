
import 'package:args/command_runner.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/config_directory_model.dart';

class DirectoryShowCommand extends Command {
  @override
  final name = "show";
  @override
  final description = "Show directories currently configured to be synced";

  ConfigModel config;

  DirectoryShowCommand(this.config);

  @override
  void run() async {
    for (ConfigDirectoryModel directory in config.syncDirectories) {
      print('Name: ${directory.name}');
      print('Directory: ${directory.localDirectory}');
      print('');
    }
  }
}

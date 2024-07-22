import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/config_directory_model.dart';
import 'package:collection/collection.dart';

class DirectoryRemoveCommand extends Command {
  @override
  final name = "remove";
  @override
  final description = "Remove a directory to be synced";

  ConfigModel config;

  DirectoryRemoveCommand(this.config);

  @override
  void run() async {
    int length = argResults?.rest.length as int;
    late String name;

    if (length == 0) {
      print("Enter in a name:");
      name = stdin.readLineSync()!;

      if (name.isEmpty) {
        print("Name cannot be empty");
        exit(1);
      }
    }

    if (length == 1) {
      name = argResults!.rest[0];
    }

    ConfigDirectoryModel? removeDirectory = config.syncDirectories
        .firstWhereOrNull(
            (ConfigDirectoryModel directory) => directory.name == name);

    if (removeDirectory == null) {
      print('$name does not exist');
      exit(1);
    }

    config.syncDirectories.remove(removeDirectory);

    Config().writeConfig(config);

    print('$name removed');
  }
}

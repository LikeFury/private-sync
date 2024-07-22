import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/config_directory_model.dart';
import 'package:collection/collection.dart';

class DirectoryAddCommand extends Command {
  @override
  final name = "add";
  @override
  final description = "Setup a directory to be synced";

  ConfigModel config;

  DirectoryAddCommand(this.config);

  @override
  void run() async {
    int length = argResults?.rest.length as int;
    late String name;
    late String localDirectory;

    if (length == 0) {
      print("Enter in a name:");
      name = stdin.readLineSync()!;

      if (name.isEmpty) {
        print("Name cannot be empty");
        exit(1);
      }
    }

    if (length == 1 || length == 0) {
      print("Enter in the local directory:");
      localDirectory = stdin.readLineSync()!;

      if (localDirectory.isEmpty) {
        print("Local directory cannot be empty");
        exit(1);
      }
    }

    if (length == 2) {
      name = argResults!.rest[0];
      localDirectory = argResults!.rest[1];
    }

    ConfigDirectoryModel? existingDirectory = config.syncDirectories
        .firstWhereOrNull(
            (ConfigDirectoryModel directory) => directory.name == name);

    if (existingDirectory != null) {
      print('$name already exists!');
      exit(1);
    }

    config.syncDirectories
        .add(ConfigDirectoryModel(name: name, localDirectory: localDirectory));

    Config().writeConfig(config);

    print('Added $name. Directory too be syned: $localDirectory');
  }
}

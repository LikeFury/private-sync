import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/models/config_sync_path_model.dart';
import 'package:private_sync/ssh.dart';

class DirectoryCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "directory";
  final description = "Setup directories you want to be synced";

  ConfigModel config;

  DirectoryCommand(this.config) {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    argParser.addFlag('show',
        abbr: 's',
        help: "Show directories currently configured to be synced",
        negatable: false);
    argParser.addFlag('remote',
        abbr: 'r',
        help: "Show synced directories on the SSH server",
        negatable: false);
    argParser.addFlag('add',
        abbr: 'a', help: "Setup a directory to be synced", negatable: false);
    /*argParser.addFlag('port',
        abbr: 'p', help: "Set SSH port", negatable: false);
    argParser.addFlag('directory',
        abbr: 'd', help: "Set path on SSH server to store", negatable: false);
    argParser.addFlag('test',
        abbr: 't', help: "Test connectivity to SSH server", negatable: false);*/
  }

  @override
  void run() async {
    if (argResults!.flag('add')) {
      print("Enter in a name:");
      String name = stdin.readLineSync()!;

      if (name.isEmpty) {
        print("Name cannot be empty");
        exit(1);
      }

      print("Enter in the local directory:");
      String localDirectory = stdin.readLineSync()!;

      if (localDirectory.isEmpty) {
        print("Local directory cannot be empty");
        exit(1);
      }

      /*bool exists = await Directory(localDirectory).exists();
      if (exists == false) {
        print("Local directory does not exist, please check the patch");
        exit(1);
      }*/

      config.syncDirectorys?.add(
          ConfigSyncPathModel(name: name, localDirectory: localDirectory));

      Config().writeConfig(config);
    }
  }
}

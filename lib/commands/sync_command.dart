import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:private_sync/config.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/ssh.dart';

class SyncCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  final name = "sync";
  final description = "Set the SSH server you wish to use";

  ConfigModel config;

  SyncCommand(this.config) {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    argParser.addFlag('show',
        abbr: 's',
        help: "Show current SSH server configuration",
        negatable: false);
    argParser.addFlag('hostname',
        abbr: 'n', help: "Set SSH hostname", negatable: false);
    argParser.addFlag('username',
        abbr: 'u', help: "Set SSH username", negatable: false);
    argParser.addFlag('port',
        abbr: 'p', help: "Set SSH port", negatable: false);
    argParser.addFlag('directory',
        abbr: 'd', help: "Set path on SSH server to store", negatable: false);
    argParser.addFlag('test',
        abbr: 't', help: "Test connectivity to SSH server", negatable: false);
  }

  @override
  void run() async {
    if (argResults!.flag('show')) {
      print("Hostname: ${config.hostname}");
      print("Username: ${config.username}");
      print("Port: ${config.port}");
      print("Remote Directory: ${config.remoteDirectory}");
    }

    if (argResults!.flag('hostname')) {
      config.hostname = argResults!.rest[0];
      Config().writeConfig(config);
      print("Hostname set to: ${config.hostname}");
    }

    if (argResults!.flag('username')) {
      config.username = argResults!.rest[0];
      Config().writeConfig(config);
      print("Username set to: ${config.username}");
    }

    if (argResults!.flag('port')) {
      try {
        config.port = int.parse(argResults!.rest[0]);
        Config().writeConfig(config);
        print("Port set to: ${config.port}");
      } catch (error) {
        print("Port must be a number!");
      }
    }

    if (argResults!.flag('directory')) {
      config.remoteDirectory = argResults!.rest[0];
      Config().writeConfig(config);
      print("SSH directory set to: ${config.remoteDirectory}");
    }

    if (argResults!.flag('test')) {
      Ssh sshClient = Ssh(config: config);
      try {
        await sshClient.connect();
        print("Successfully connected");
      } catch (e) {
        print("Connection error: $e");
        await sshClient.close();
        exit(1);
      }

      try {
        sshClient.createDirectory("${config.remoteDirectory}/test");
        sshClient.deleteDirectory("${config.remoteDirectory}/test");
        print('Remote directory is writable');
      } catch (e) {
        print("Directory error: $e");
        print("Ensure the remote directory exists and is writable");
        await sshClient.close();
        exit(1);
      }

      await sshClient.close();
    }
  }
}

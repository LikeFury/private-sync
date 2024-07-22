import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/ssh.dart';

class ServerTestCommand extends Command {
  @override
  final name = "test";
  @override
  final description = "Test the SSH configuration";

  ConfigModel config;

  ServerTestCommand(this.config);

  @override
  void run() async {
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

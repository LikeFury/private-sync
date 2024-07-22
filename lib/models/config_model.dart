import 'package:private_sync/models/config_directory_model.dart';

class ConfigModel {
  String hostname;
  int port;
  String username;
  String remoteDirectory;
  String? password;
  String? privateKeyDirectory;
  List<ConfigDirectoryModel> syncDirectories;

  ConfigModel(
      {required this.hostname,
      this.port = 22,
      required this.username,
      this.password,
      required this.remoteDirectory,
      this.privateKeyDirectory,
      this.syncDirectories = const []});

  Map<String, dynamic> toMap() {
    return {
      'hostname': hostname,
      'port': port,
      'username': username,
      'password': password,
      'remote_directory': remoteDirectory,
      'private_key_directory': privateKeyDirectory,
      'sync_directories':
          syncDirectories.map((directory) => directory.toMap()).toList()
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
        hostname: map['hostname'],
        port: map['port'] ?? 22,
        username: map['username'],
        password: map['passsword'],
        remoteDirectory: map['remote_directory'],
        privateKeyDirectory: map['private_key_directory'],
        syncDirectories: map['sync_directories']
            .map<ConfigDirectoryModel>(
                (sync) => ConfigDirectoryModel.fromMap(sync))
            .toList());
  }
}

import 'package:private_sync/models/config_sync_path_model.dart';

class ConfigModel {
  String hostname;
  int port;
  String username;
  String remoteDirectory;
  String? password;
  String? privateKeyDirectory;
  List<ConfigSyncPathModel>? syncDirectorys;

  ConfigModel(
      {required this.hostname,
      this.port = 22,
      required this.username,
      this.password,
      required this.remoteDirectory,
      this.privateKeyDirectory,
      this.syncDirectorys});

  Map<String, dynamic> toMap() {
    return {
      'hostname': hostname,
      'port': port,
      'username': username,
      'password': password,
      'remote_directory': remoteDirectory,
      'private_key_directory': privateKeyDirectory,
      'sync_directories': []
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
        syncDirectorys: map['sync_directories']
            .map<ConfigSyncPathModel>(
                (sync) => ConfigSyncPathModel.fromMap(sync))
            .toList());
  }
}

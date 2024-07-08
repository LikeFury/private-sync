import 'package:private_sync/sync_model.dart';

class ConfigModel {
  String hostname;
  int port;
  String username;
  String? password;
  String? privateKeyDirectory;
  List<SyncModel> syncDirectorys;

  ConfigModel(
      {required this.hostname,
      this.port = 22,
      required this.username,
      this.password = null,
      this.privateKeyDirectory = null,
      required this.syncDirectorys});

  Map<String, dynamic> toMap() {
    return {
      'hostname': hostname,
      'port': port,
      'username': username,
      'password': password,
      'private_key_directory': privateKeyDirectory
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
        hostname: map['hostname'],
        port: map['port'] ?? 22,
        username: map['username'],
        password: map['passsword'],
        privateKeyDirectory: map['private_key_directory'],
        syncDirectorys: map['sync_directorys']
            .map<SyncModel>((sync) => SyncModel.fromMap(sync))
            .toList());
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:private_sync/models/config_model.dart';
import 'package:private_sync/os.dart';

class Config {
  late String filePath;

  Config() {
    filePath = '${Os().getHomeDirectory()}/.private-sync.json';
  }

  bool exists() {
    return File(filePath).existsSync();
  }

  /// Load config
  ConfigModel loadConfig() {
    var json = File(filePath).readAsStringSync();
    var map = jsonDecode(json);

    return ConfigModel.fromMap(map);
  }

  /// Write config out
  void writeConfig(ConfigModel config) {
    var json = jsonEncode(config.toMap());
    File(filePath).writeAsStringSync(json);
  }
}

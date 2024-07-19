class ConfigSyncPathModel {
  String name;
  String localDirectory;

  ConfigSyncPathModel({required this.name, required this.localDirectory});

  Map<String, dynamic> toMap() {
    return {'name': name, 'local_directory': localDirectory};
  }

  factory ConfigSyncPathModel.fromMap(Map<String, dynamic> map) {
    return ConfigSyncPathModel(
        name: map['name'], localDirectory: map['local_directory']);
  }
}

class ConfigDirectoryModel {
  String name;
  String localDirectory;

  ConfigDirectoryModel({required this.name, required this.localDirectory});

  Map<String, dynamic> toMap() {
    return {'name': name, 'local_directory': localDirectory};
  }

  factory ConfigDirectoryModel.fromMap(Map<String, dynamic> map) {
    return ConfigDirectoryModel(
        name: map['name'], localDirectory: map['local_directory']);
  }
}

class SyncDirectoryModel {
  String name;
  String localDirectory;

  SyncDirectoryModel({required this.name, required this.localDirectory});

  Map<String, dynamic> toMap() {
    return {'name': name, 'local_directory': localDirectory};
  }

  factory SyncDirectoryModel.fromMap(Map<String, dynamic> map) {
    return SyncDirectoryModel(
        name: map['name'], localDirectory: map['local_directory']);
  }
}

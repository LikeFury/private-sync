class SyncModel {
  String name;
  String localDirectory;

  SyncModel({required this.name, required this.localDirectory});

  Map<String, dynamic> toMap() {
    return {'name': name, 'local_directory': localDirectory};
  }

  factory SyncModel.fromMap(Map<String, dynamic> map) {
    return SyncModel(name: map['name'], localDirectory: map['local_directory']);
  }
}

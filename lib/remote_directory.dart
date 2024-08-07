import 'package:private_sync/models/remote_directory_listing_model.dart';
import 'package:private_sync/models/sync_directory_model.dart';
import 'package:private_sync/models/sync_file_model.dart';
import 'package:private_sync/ssh.dart';

class RemoteDirectory {
  Ssh sshClient;

  late String path;
  List<SyncFileModel> files = [];
  List<SyncDirectoryModel> directories = [];

  DateTime lastestFileTime = DateTime(1900);

  RemoteDirectory(this.sshClient, this.path) {
    var lastPathChar = path.substring(path.length - 1);
    if (lastPathChar != '/') {
      path = "$path/";
    }
  }

  Future<void> parseDirectory() async {
    RemoteDirectoryListingModel directoryListing = await sshClient.listDirectory(path);

    for (var file in directoryListing.files) {
      if (file.modifyTime.isAfter(lastestFileTime)) {
        lastestFileTime = file.modifyTime;
      }
    }

    directories = directoryListing.directories;
    files = directoryListing.files;
  }
}

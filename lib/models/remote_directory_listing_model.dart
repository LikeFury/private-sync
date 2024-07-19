import 'package:private_sync/models/sync_directory_model.dart';
import 'package:private_sync/models/sync_file_model.dart';

class RemoteDirectoryListingModel {
  List<SyncFileModel> files = [];
  List<SyncDirectoryModel> directories = [];

  RemoteDirectoryListingModel(this.files, this.directories);
}

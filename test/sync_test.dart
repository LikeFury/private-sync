import 'dart:developer';
import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_file_model.dart';

import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';
import 'package:private_sync/sync.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Ssh>()])
@GenerateNiceMocks([MockSpec<RemoteDirectory>()])
@GenerateNiceMocks([MockSpec<LocalDirectory>()])
import 'sync_test.mocks.dart';

void main() async {
  test('Sync local to remote', () async {
    var remote = MockRemoteDirectory();

    remote.files.add(
        SyncFileModel('/remote/test/sync/file1', DateTime(2020, 9, 7, 17, 30)));
    remote.files.add(SyncFileModel(
        '/remote/test/sync/dir1/file2', DateTime(2021, 9, 7, 17, 30)));
    remote.files.add(SyncFileModel(
        '/remote/test/sync/dir1/dir3/file3', DateTime(2022, 9, 7, 17, 30)));

    when(remote.lastestFileTime).thenReturn(DateTime(2022, 9, 7, 17, 30));
    when(remote.path).thenReturn('/home/test/sync/');

    var local = MockLocalDirectory();

    local.files.add(
        SyncFileModel('/home/test/sync/file1', DateTime(2020, 9, 7, 17, 30)));
    local.files.add(SyncFileModel(
        '/home/test/sync/dir1/file2', DateTime(2021, 9, 7, 17, 30)));
    local.files.add(SyncFileModel(
        '/home/test/sync/dir1/dir3/file3', DateTime(2023, 9, 7, 17, 30)));

    when(local.lastestFileTime).thenReturn(DateTime(2023, 9, 7, 17, 30));
    when(local.path).thenReturn('/home/test/sync/');

    Sync().sync(local, remote);
  });
}

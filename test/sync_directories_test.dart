import 'package:file/memory.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/models/sync_directory_model.dart';

import 'package:private_sync/remote_directory.dart';
import 'package:private_sync/ssh.dart';
import 'package:private_sync/sync.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Ssh>()])
@GenerateNiceMocks([MockSpec<RemoteDirectory>()])
@GenerateNiceMocks([MockSpec<LocalDirectory>()])
import 'sync_directories_test.mocks.dart';

void main() async {
  test('Sync directories from local to remote', () async {
    var remote = MockRemoteDirectory();
    when(remote.path).thenReturn('/remote/sync/');
    when(remote.directories).thenReturn([SyncDirectoryModel('/remote/sync/dir1')]);

    var local = MockLocalDirectory();
    when(local.path).thenReturn('/home/test/sync/');
    when(local.directories).thenReturn([
      SyncDirectoryModel('/home/test/sync/dir1'),
      SyncDirectoryModel('/home/test/sync/dir2'),
      SyncDirectoryModel('/home/test/sync/dir1/subdir1'),
      SyncDirectoryModel('/home/test/sync/dir1/subdir2'),
      SyncDirectoryModel('/home/test/sync/dir1/subdir2/deepdir1')
    ]);

    var ssh = MockSsh();

    var memoryFileSystem = MemoryFileSystem();
    memoryFileSystem.directory('/home/test/sync').createSync(recursive: true);

    await Sync(ssh, memoryFileSystem).syncDirectories(local, remote);

    verifyNever(ssh.createDirectory('/remote/sync/dir1'));
    verify(ssh.createDirectory('/remote/sync/dir2')).called(1);
    verify(ssh.createDirectory('/remote/sync/dir1/subdir1')).called(1);
    verify(ssh.createDirectory('/remote/sync/dir1/subdir2')).called(1);
    verify(ssh.createDirectory('/remote/sync/dir1/subdir2/deepdir1')).called(1);
  });

  test('Sync directories from remote to local', () async {
    var remote = MockRemoteDirectory();
    when(remote.path).thenReturn('/remote/sync/');
    when(remote.directories).thenReturn([
      SyncDirectoryModel('/remote/sync/dir1'),
      SyncDirectoryModel('/remote/sync/dir1/subdir1'),
      SyncDirectoryModel('/remote/sync/dir1/subdir2'),
      SyncDirectoryModel('/remote/sync/dir1/subdir2/deepdir1')
    ]);

    var local = MockLocalDirectory();
    when(local.path).thenReturn('/home/test/sync/');
    when(local.directories).thenReturn([SyncDirectoryModel('/home/test/sync/dir1')]);

    var ssh = MockSsh();
    var memoryFileSystem = MemoryFileSystem();
    memoryFileSystem.directory('/home/test/sync/dir1').createSync(recursive: true);

    await Sync(ssh, memoryFileSystem).syncDirectories(local, remote);

    expect(memoryFileSystem.directory('/home/test/sync/dir1/subdir1').existsSync(), true);
    expect(memoryFileSystem.directory('/home/test/sync/dir1/subdir2').existsSync(), true);
    expect(memoryFileSystem.directory('/home/test/sync/dir1/subdir2/deepdir1').existsSync(), true);
  });
}

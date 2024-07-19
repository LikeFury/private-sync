import 'dart:io';
import 'package:private_sync/local_directory.dart';
import 'package:private_sync/os.dart';
import 'package:test/test.dart';

void main() async {
  test('Local Directory parses directory correctly', () async {
    var file1 =
        await File('${Directory.current.path}/test/fixtures/local/dir1/file1')
            .create(recursive: true);
    await file1.setLastModified(DateTime(2020, 9, 7, 17, 30));

    var file2 =
        await File('${Directory.current.path}/test/fixtures/local/dir1/file2')
            .create(recursive: true);
    await file2.setLastModified(DateTime(2021, 9, 7, 17, 30));

    var file3 =
        await File('${Directory.current.path}/test/fixtures/local/dir2/file3')
            .create(recursive: true);
    await file3.setLastModified(DateTime(2022, 9, 7, 17, 30));

    var file4 = await File('${Directory.current.path}/test/fixtures/local/file')
        .create(recursive: true);
    await file4.setLastModified(DateTime(2024, 1, 1, 1, 30));

    LocalDirectory local =
        LocalDirectory('${Directory.current.path}/test/fixtures/local');

    await local.parseDirectory();

    expect(local.files.length, 4);
    expect(local.directories.length, 2);
    expect(local.lastestFileTime, DateTime(2024, 1, 1, 1, 30));

    await file1.delete();
    await file2.delete();
    await file3.delete();
    await file4.delete();
  });

  test('~ resolves to home directory', () {
    LocalDirectory local = LocalDirectory('~/sync');

    expect(local.path, '${Os().getHomeDirectory()}/sync');
  });
}

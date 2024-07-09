import 'dart:developer';
import 'dart:io';

import 'package:private_sync/local_directory.dart';
import 'package:test/test.dart';

/*void main() async {
  test('Local Directory parses directory correctly', () async {
    
    LocalDirectory local =
        LocalDirectory(Directory.current.path + "/test/fixtures/local");

    await local.parseDirectory();

    await expectLater(
        local.parseDirectory(), completion(local.files.length == 6));
  });
}*/

void main() async {
  test('Test output gets updates', () async {
    Test test = Test();

    await test.update();

    expect(test.output, 'Future Updated');
  });
}

class Test {
  String output = '';

  Future<void> update() async {
    await Future.delayed(Duration(seconds: 1), () {
      output = 'Future Updated';
    });
  }
}

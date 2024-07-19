import 'dart:io';

class Os {
  /// Get the home directory from the environment
  String getHomeDirectory() {
    String home = "";
    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME'] as String;
    } else if (Platform.isLinux) {
      home = envVars['HOME'] as String;
    } else if (Platform.isWindows) {
      home = envVars['UserProfile'] as String;
    }

    return home;
  }
}

import 'package:package_info_plus/package_info_plus.dart';

enum Env { stage, prod, dev }

class BuildConfig {
  static late String appName;
  static late String apiBaseUrl;

  static late int buildNo;
  static String? packageName;
  static String? versionName;

  static void init(PackageInfo package) {
    buildNo = int.parse(
      package.buildNumber.replaceAll(RegExp("[a-z]"), ""),
    );
    packageName = package.packageName;
    versionName = package.version;
  }
}

class AppDetails {
  final int buildNumber;
  final String version;
  final String changeLog;
  final bool force;
  final String urlAndroid;
  final String urlIos;
  final String privacyPolicyLink;
  final String termsAndConditionsLink;

  AppDetails({
    required this.buildNumber,
    required this.version,
    required this.changeLog,
    required this.force,
    required this.urlAndroid,
    required this.urlIos,
    required this.privacyPolicyLink,
    required this.termsAndConditionsLink,
  });

  factory AppDetails.fromJson(Map<String, dynamic> data) {
    return AppDetails(
      buildNumber: data['build_number'] ?? 0,
      version: data['version'] ?? '',
      changeLog: data['change_log'] ?? '',
      force: data['force'] ?? false,
      urlAndroid: data['app_url_android'] ?? '',
      urlIos: data['app_url_ios'] ?? '',
      privacyPolicyLink: data['privacy_policy_link'] ?? '',
      termsAndConditionsLink: data['terms_and_conditions'] ?? '',
    );
  }
}

class ApiPath {

  /// Authentication
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String logout = '$auth/logout';
  static const String register = '$auth/register';
  static const String forgotPassword = '$auth/forgot-password';
  static const String verifyOtp = '$auth/verify-otp';
  static const String resetPassword = '$auth/reset-password';

  /// Profile
  static const String changePassword = '/change-password';

  /// Force Update
  static const String getDetails = '/get-details';
}


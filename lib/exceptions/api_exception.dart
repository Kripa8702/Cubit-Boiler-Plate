// custom exception class for handling exceptions with status and message params
class ApiException implements Exception {
  final int? status;
  final String message;

  ApiException(this.message, {this.status = 500});

  @override
  String toString() {
    return 'ApiException{status: $status, message: $message}';
  }
}

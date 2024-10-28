class CommonResponse {
  const CommonResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final dynamic data;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? "An error occurred. Please try again later.",
    data: json['data'] ?? {},
  );
}


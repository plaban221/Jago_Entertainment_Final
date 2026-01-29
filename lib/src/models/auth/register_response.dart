class RegisterResponse {
  final int status;
  final String message;
  // final String token;

  RegisterResponse({
    required this.status,
    required this.message,
    // required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'],
      message: json['message'],
      // token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      // 'token': token,
    };
  }
}


import 'package:jagoentertainment/src/models/auth/user_data.dart';

class ProfileResponse {
  final int status;
  final String message;
  UserData? data;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/core/constants/app_strings.dart';
import 'package:jagoentertainment/src/models/auth/login_params.dart';
import 'package:jagoentertainment/src/models/auth/login_response.dart';
import 'package:jagoentertainment/src/models/auth/register_params.dart';
import 'package:jagoentertainment/src/models/auth/register_response.dart';

class AuthRemoteDatasource extends BaseRemoteDatasource {
  static AuthRemoteDatasource get to => Get.find();

  Future<RegisterResponse> registerUser(RegisterParams params) async {
    try {
      final endpoint = "$baseUrl/v1/auth/register";

      final api = dioClient.post(
        endpoint,
        data: params.toJson(),
      );

      final response = await callApi(api);
      final json = response.data;

      logger.d(json);
      return RegisterResponse.fromJson(json);
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginResponse> loginUser(LoginParams params) async {
    try {
      final endpoint = "$baseUrl/v1/auth/login";

      final api = dioClient.post(
        endpoint,
        data: params.toJson(),
      );

      final response = await callApi(api);
      final json = response.data;

      logger.d(json);
      return LoginResponse.fromJson(json);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> sendOtp(String email) async {
    try {
      final endpoint = "$baseUrl/v1/auth/forget-password";

      final api = dioClient.post(
        endpoint,
        data: {
          'email': email,
        },
      );

      final response = await callApi(api);
      final json = response.data;

      logger.d(json);
      return json['message'];
    } catch (error) {
      rethrow;
    }
  }

  Future<String> verifyOtp(String otp, String email) async {
    try {
      final endpoint = "$baseUrl/v1/auth/verify-otp";

      final api = dioClient.post(
        endpoint,
        data: {
          'otp': otp,
          'email': email
        },
      );

      final response = await callApi(api);
      final json = response.data;

      logger.d(json);
      return json['message'];
    } catch (error) {
      rethrow;
    }
  }

  // Future<String> resetPassword(ResetPasswordParams params) async {
  //   try {
  //     final endpoint = "$baseUrl/v1/auth/reset-password";
  //
  //     final api = dioClient.post(
  //       endpoint,
  //       data: params.toJson(),
  //     );
  //
  //     final response = await callApi(api);
  //     final json = response.data;
  //
  //     logger.d(json);
  //     return json['message'];
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<String> getApiAccessToken() async {
  //   try {
  //     const endpoint = "${AppStrings.productUrl}/api/v1/auth";
  //
  //     final api = dioClient.post(
  //       endpoint,
  //       data: {
  //         "API_KEY": "0d3d38b214e57ed7c307a41147a89c6d5e7cafe97e8e82651a8997426214b1a1"
  //       },
  //     );
  //
  //     final response = await callApi(api);
  //     final json = response.data;
  //
  //     logger.d(json);
  //     return json['token'] ?? '';
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
}

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/models/profile/profile_edit_params.dart';
import 'package:jagoentertainment/src/models/profile/profile_response.dart';

class ProfileRemoteDatasource extends BaseRemoteDatasource {
  static ProfileRemoteDatasource get to => Get.find();

  Future<ProfileResponse> getProfile() async {
    try {
      final endpoint = "$baseUrl/v1/myinfo";

      final api = dioClient.get(
        endpoint,
      );

      final response = await callApi(api);
      final json = response.data;
      logger.d(json);
      return ProfileResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ProfileResponse> updateProfile(ProfileEditParams params, dio.MultipartFile? profileImage) async {
    try {
      final endpoint = "$baseUrl/v1/update-profile";

      logger.d(profileImage);
      final dataMap = params.toJson();
      if (profileImage != null) {
        dataMap['image'] = profileImage;
      }

      final formData = dio.FormData.fromMap(dataMap);

      final api = dioClient.put(
        endpoint,
        data: formData,
      );

      final response = await callApi(api);
      return ProfileResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  // Future<UpdatePasswordResponse> changePassword(UpdatePasswordParams params) async {
  //   try {
  //     final endpoint = "$baseUrl/v1/change-password";
  //
  //     final api = dioClient.put(
  //       endpoint,
  //       data: params.toJson(),
  //     );
  //
  //     final response = await callApi(api);
  //     return UpdatePasswordResponse.fromJson(response.data);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

}
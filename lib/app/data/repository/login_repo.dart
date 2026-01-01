import 'package:chatapp/app/core/base/base_repo.dart';
import 'package:chatapp/app/core/network/dio_client.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';

class LoginRepo extends BaseRepo {
  Future<Map<String, dynamic>> login(String phoneNumber, String email) async {
    var res = await DioClient.getInstance().post(
      AppUrls.login(),
      data: {"phoneNumber": phoneNumber, "email": email},
    );
    return res.data;
  }

  Future<Map<String, dynamic>> otpVerification(
    String phoneNumber,
    String otp,
  ) async {
    var res = await DioClient.getInstance().post(
      AppUrls.otpverification(),
      queryParameters: {"phoneNumber": phoneNumber, "otp": otp},
    );
    return res.data;
  }

  Future<Map<String, dynamic>> addUser(
    String name,
    String about,
    String bio,
    String profileUrl,
  ) async {
    var res = await DioClient.getInstance().post(
      AppUrls.addUser(),
      data: {
        "name": name,
        "about": about,
        "bio": bio,
        "profileUrl": profileUrl,
      },
    );
    return res.data;
  }

  Future<UserDetailModel> getUserById(String id) async {
    try {
      final res = await DioClient.getInstance().get(
        AppUrls.getUserById(),
        queryParameters: {"id": id},
      );
      return UserDetailModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserDetailModel>> getAllUser() async {
    try {
      final res = await DioClient.getInstance().get(AppUrls.getAllUser());
      List list = res.data['data'];
      return list.map((e) => UserDetailModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

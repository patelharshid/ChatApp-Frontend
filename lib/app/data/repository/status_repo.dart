import 'package:chatapp/app/core/base/base_repo.dart';
import 'package:chatapp/app/core/network/dio_client.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';
import 'package:chatapp/app/data/model/status_detail_model.dart';

class StatusRepo extends BaseRepo {
  Future<String> saveStatus({
    required String contentUrl,
    required String caption,
  }) async {
    try {
      final res = await DioClient.getInstance().post(
        AppUrls.saveSatus(),
        queryParameters: {"contentUrl": contentUrl, "caption": caption},
      );
      return res.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StatusDetailModel>> getAllStatus() async {
    try {
      final res = await DioClient.getInstance().get(AppUrls.saveSatus());
      final List data = res.data['data'];
      return data.map((e) => StatusDetailModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> markAsViewed({required int statusId}) async {
    try {
      final res = await DioClient.getInstance().post(
        AppUrls.markAsViewed(),
        queryParameters: {"statusId": statusId},
      );
      return res.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}

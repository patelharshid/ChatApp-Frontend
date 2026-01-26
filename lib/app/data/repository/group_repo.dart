import 'package:chatapp/app/core/base/base_repo.dart';
import 'package:chatapp/app/core/network/dio_client.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';

class GroupRepo extends BaseRepo {
  Future<Map<String, dynamic>> createGroup(
    String groupName,
    List<int> memberUserIds,
  ) async {
    final res = await DioClient.getInstance().post(
      AppUrls.createGroup(),
      data: {"groupName": groupName, "memberUserIds": memberUserIds},
    );
    return res.data;
  }
}

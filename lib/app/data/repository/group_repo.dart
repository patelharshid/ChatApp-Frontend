import 'package:chatapp/app/core/base/base_repo.dart';
import 'package:chatapp/app/core/network/dio_client.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';
import 'package:chatapp/app/data/model/group_message_model.dart';

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

  Future<List<GroupMessageModel>> groupMessage(int groupId) async {
    final res = await DioClient.getInstance().get(
      AppUrls.groupMessage(),
      queryParameters: {"groupId": groupId},
    );
    List list = res.data['data'];
    return list.map((e) => GroupMessageModel.fromJson(e)).toList();
  }
}

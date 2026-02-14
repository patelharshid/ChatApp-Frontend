import 'package:chatapp/app/core/base/base_repo.dart';
import 'package:chatapp/app/core/network/dio_client.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';
import 'package:chatapp/app/data/model/chat_user_detail_model.dart';
import 'package:chatapp/app/data/model/message_model.dart';

class ChatReop extends BaseRepo {
  Future<List<ChatUserDetailModel>> getChatUsers() async {
    try {
      final res = await DioClient.getInstance().get(AppUrls.getChatUsers());
      List list = res.data['data'];
      return list.map((e) => ChatUserDetailModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MessageModel>> getMessageList(int id) async {
      try {
      final res = await DioClient.getInstance().get(
        AppUrls.getMessageList(),
        queryParameters: {
          "userId": id,
        },
      );
      List list = res.data['data'];
      return list.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

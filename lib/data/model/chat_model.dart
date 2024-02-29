import 'package:heritage_map/data/model/message_model.dart';

class ChatModel {
  String user;
  List<MessageModel> messages;

  ChatModel({required this.user, required this.messages});
}

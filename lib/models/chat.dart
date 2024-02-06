import 'package:chatbot/models/message.dart';

class Chat {
  late String title;
  final List<Message> messages;

  Chat({required this.title, required this.messages});

}

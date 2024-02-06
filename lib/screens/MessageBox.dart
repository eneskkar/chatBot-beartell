// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, unused_element

//import 'package:chatbot/models/message.dart';
import 'package:chatbot/screens/MessageList.dart';
import 'package:chatbot/screens/NewMessageInput.dart';
import 'package:flutter/material.dart';
//import 'ChatScreen.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openHistoryPanel() {
    _scaffoldKey.currentState!.openEndDrawer();
  }
  //final List<ChatMessage> _messages = <ChatMessage>[];
  // void _handleSubmitted(String text) {
  //   _MessageTextController.clear();
  //   ChatMessage message = ChatMessage(
  //     text: text,
  //   );
  //   setState(() {
  //     _messages.insert(0, message);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.settings, size: 40),
                          SizedBox(width: 8.0, height: 50),
                          Expanded(
                            child: Text(
                                'You are a helpful assistant. You can help me by answering my questions. You can also ask me questions. \nWord count: 19'), //// kullanıcın prompt una gçre değişecek bu kısım!!
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: MessageList(),
              // ListView.builder(
              //   padding: const EdgeInsets.all(8.0),
              //   reverse: true,
              //   itemBuilder: (_, int index) => _messages[index],
              //   itemCount: _messages.length,
              // ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
            NewMessageInput(),
          ],
        ),
      
    );
  }
}

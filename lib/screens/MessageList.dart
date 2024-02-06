// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatbot/providers/chat_provider.dart';

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);
    
    //String? response = Provider.of<ChatProvider>(context).response;
    return ListView.builder(
      itemCount: chatProvider.currentMessages.length,
      itemBuilder: (context, index) {
        var message = chatProvider.currentMessages[index];
        return Column(
          children: [
            Divider(thickness: 1),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  message.sender[0],
                  style: TextStyle(fontSize: 16),
                ),
              ),
              title: Text('${message.sender}: ${message.text}'),
              //response ?? ""
              //style: TextStyle(color: Colors.grey.shade800),
            ),
            Divider(thickness: 1),
            ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text(
                    "Ass.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                title: Letters(text: message.answers)),
          ],
        );
      },
    );
  }
}


class Letters extends StatefulWidget {
  final String? text;

  const Letters({required this.text});

  @override
  _LettersState createState() => _LettersState();
}

class _LettersState extends State<Letters> {
  late String endText;
  late int index;

  @override
  void initState() {
    super.initState();
    endText = "";
    index = 0;
    _printAnswer();
  }

  Future<void> _printAnswer() async {
    for (int i = 0; i < widget.text!.length; i++) {
      await Future.delayed(Duration(milliseconds: 5));
      setState(() {
        endText = widget.text!.substring(0, i + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      endText,
      style: TextStyle(fontSize: 16),
    );
  }
}

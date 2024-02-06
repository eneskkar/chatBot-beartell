// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names

import 'package:chatbot/services/ChatServices.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/models/message.dart';

import 'package:provider/provider.dart';
import 'package:chatbot/providers/chat_provider.dart';

class NewMessageInput extends StatefulWidget {
  @override
  _NewMessageInputState createState() => _NewMessageInputState();
}

class _NewMessageInputState extends State<NewMessageInput> {
  final TextEditingController _MessageTextController = TextEditingController();
  bool isCheckedShowReferences = false;
  //String? response;

  Future<void> _openRAG() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Local Documents'),
              content: Visibility(
                child: Row(
                  children: [
                    Checkbox(
                      value: isCheckedShowReferences,
                      onChanged: (value) {
                        setState(() {
                          isCheckedShowReferences = value!;
                        });
                      },
                    ),
                    Text('Settings'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    // Burada temizleme işlemini gerçekleştirebilirsiniz.
                  },
                  child: Text('Clean It Up'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);
    String? response;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Ink(
            decoration: ShapeDecoration(
              //color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            child: IconButton(
              color: Colors.deepPurple,
              splashColor: Colors.deepPurple,
              icon: Icon(Icons.add),

              onPressed: _openRAG, ////// add butonu action kısmı
            ),
          ),
        ),
        Flexible(
          child: TextFormField(
            controller: _MessageTextController,
            //onSubmitted: _handleSubmitted,
            decoration: InputDecoration(
              labelText: "Prompt",
              hintText: 'Type a message',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Ink(
            decoration: ShapeDecoration(
              //color:  Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Köşe yarıçapı ayarlama
                side: BorderSide(color: Colors.grey), // Kenar çizgisi
              ),
            ),
            child: IconButton(
              color: Colors.deepPurple,
              icon: Icon(Icons.send),
              onPressed: () async {
                //print(_MessageTextController.text);
                response =
                    await ChatService().request(_MessageTextController.text);

                setState(() {});
                var message = Message(
                    sender: 'User ',
                    text: _MessageTextController.text,
                    answers: response);
                chatProvider.addMessageToCurrentChat(message);

                _MessageTextController.clear();
              },
              // onPressed: () => _handleSubmitted(_MessageTextController
              //     .text), ////// Message send butonu action kısmı
            ),
          ),
        ),
      ]),
    );
  }
}

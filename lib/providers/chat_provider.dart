// providers/chat_provider.dart

// ignore_for_file: prefer_final_fields

import 'package:chatbot/models/copilots.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/models/chat.dart';
import 'package:chatbot/models/message.dart';
//import 'package:chatbot/models/answers.dart';

class ChatProvider with ChangeNotifier {

  //////////new chat providers
  List<Chat> _chats = [];
  int _currentChatIndex = 0;

  List<Chat> get chats => _chats;
  int get currentChatIndex => _currentChatIndex;

  void addChat(Chat chat) {
    _chats.add(chat);
    notifyListeners();
  }

  void updateChatName(int index, String newName) {
    chats[index] = Chat(title: newName, messages: chats[index].messages);
    notifyListeners();
  }

  void switchChat(int index) {
    _currentChatIndex = index;
    notifyListeners();
  }

  List<Message> get currentMessages =>
      _chats.isNotEmpty ? _chats[_currentChatIndex].messages : [];

  void addMessageToCurrentChat(Message message) {
    _chats[_currentChatIndex].messages.add(message);

    notifyListeners();
  }

  void createNewChat() {
    var newChat = Chat(
      title: 'Untitled ${_chats.length + 1}',
      messages: [],
    );
    addChat(newChat);
  }

  ///// dark-light mode 
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ///// copilots providers
  List<Copilots> _copilots = [];
  int _currentCopilotsIndex = 0;

  List<Copilots> get copilots => _copilots;
  int get currentCopilotsIndex => _currentCopilotsIndex;
  
  
  void createNewCopilots(Copilots copilot){
    _copilots.add(copilot);
    notifyListeners();
  
  }

}

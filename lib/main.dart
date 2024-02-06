// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:chatbot/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return MaterialApp(
            theme: chatProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            title: 'ChatBot',
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

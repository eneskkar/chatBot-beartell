import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chatbot/apis/apiKey.dart';
//import 'chatRequest.dart';
//import 'chatResponse.dart';

class ChatService {
  static final Uri chatUri = Uri.parse(
      'http://192.168.68.153:3030/v1/chat/completions'); //  https://api.openai.com/v1/chat/completions

  Future<String?> request(String prompt) async {
    try {
      var response = await http.post(
        chatUri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
        },
        body: jsonEncode({
          'model': 'local-model', // Bu alan şu anda kullanılmıyor
          'messages': [
            {'role': 'system', 'content': 'Always answer in rhymes.'},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        }),
      );
      //print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data['choices'][0]['message']['content']);
        //print(data);
        return data['choices'][0]['message']['content'];
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      // ChatResponse chatResponse = ChatResponse.fromResponse(response);
      // //print(chatResponse);
      // print(chatResponse.choices?[0].message?.content);
      // return chatResponse.choices?[0].message?.content;
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}

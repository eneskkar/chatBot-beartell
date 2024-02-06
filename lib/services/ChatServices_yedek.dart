import 'package:http/http.dart' as http;
import 'package:chatbot/apis/apiKey.dart';
import 'chatRequest.dart';
import 'chatResponse.dart';

class ChatService {
  static final Uri chatUri = Uri.parse('http://192.168.68.153:3030/v1');   //  https://api.openai.com/v1/chat/completions

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };

  Future<String?> request(String prompt) async {
    try {
      //ChatRequest request = ChatRequest(model: "local-model", maxTokens: 5000, messages: [Message(role: "system", content: prompt)]);
      
      ChatRequest request = ChatRequest(
        model: "local-model", 
        messages: [Message(role: "system", content: prompt)],
        temperature: 0.7,
        maxTokens: -1,
        stream: true,
      );
      
      // if (prompt.isEmpty) {
      //   return null;
      // }
      
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      
      
      ChatResponse chatResponse = ChatResponse.fromResponse(response);
      //print(chatResponse);
      print(chatResponse.choices?[0].message?.content);
      return chatResponse.choices?[0].message?.content;
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  static const String apiKey = 'YOUR_OPENAI_API_KEY'; // Replace this
  static const String endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> getBotReply(String userMessage) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are EcoBot, a helpful eco-advisor."},
          {"role": "user", "content": userMessage}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      return 'Sorry, something went wrong.';
    }
  }
}


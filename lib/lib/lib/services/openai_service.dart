import 'package:flutter/material.dart';
import 'package:waste_wise/services/openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final OpenAIService _openAI = OpenAIService();
  bool _loading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    final userMessage = _controller.text;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _loading = true;
      _controller.clear();
    });

    final reply = await _openAI.sendMessage(userMessage);

    setState(() {
      _messages.add({'role': 'bot', 'text': reply});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EcoBot Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return ListTile(
                  title: Text(msg['text']!,
                      style: TextStyle(
                          color: isUser ? Colors.green : Colors.black87)),
                  subtitle: Text(isUser ? "You" : "EcoBot"),
                );
              },
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Ask EcoBot..."),
                )),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


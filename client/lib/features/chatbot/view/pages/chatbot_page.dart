import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'fromUser': false, 'text': 'Bonjour ! Posez-moi une question.'},
  ];
  final List<Map<String, String>> _history = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;
    setState(() {
      _messages.add({'fromUser': true, 'text': userInput});
      _isLoading = true;
    });
    _controller.clear();

    // Build history for backend
    if (_messages.length > 1) {
      final prevTurns = _messages
          .where((m) => m['fromUser'] != null)
          .toList();
      _history.clear();
      for (int i = 0; i < prevTurns.length - 1; i += 2) {
        if (i + 1 < prevTurns.length) {
          _history.add({
            'user': prevTurns[i]['text'],
            'bot': prevTurns[i + 1]['text'],
          });
        }
      }
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userInput,
          'history': _history,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sources = data['sources'] as List<dynamic>?;
        final hasGoodSource = sources != null && sources.isNotEmpty && (sources.first['score'] ?? 0) > 0.5;
        String botReply = data['response']?.toString() ?? '';
        if (!hasGoodSource) {
          botReply = "Désolé, je n'ai pas trouvé d'information pertinente dans ma base de connaissances.";
        }
        setState(() {
          _messages.add({'fromUser': false, 'text': botReply});
        });
      } else {
        setState(() {
          _messages.add({'fromUser': false, 'text': "Erreur de connexion au serveur."});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'fromUser': false, 'text': "Erreur lors de l'envoi de la requête."});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        title: Text(
          'Chatbot',
          style: AppTypography.h5.copyWith(color: Palette.gray900),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = _messages[index]['fromUser'] as bool;
                final text = _messages[index]['text'] as String;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Palette.primary : Palette.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (!isUser)
                          BoxShadow(
                            color: Palette.gray200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: AppTypography.bodyRegular14.copyWith(
                        color: isUser ? Colors.white : Palette.gray900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              color: Palette.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'Posez votre question...'
                            ,
                        hintStyle: AppTypography.bodyRegular14
                            .copyWith(color: Palette.gray400),
                        filled: true,
                        fillColor: Palette.gray50,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Palette.primary,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isLoading ? null : _sendMessage,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.send, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

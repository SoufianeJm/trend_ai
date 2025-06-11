import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {'fromUser': false, 'text': 'Hello! How can I help you today?'},
      {'fromUser': true, 'text': 'Show me the latest news headlines.'},
      {'fromUser': false, 'text': 'Here are today\'s top stories...'},
    ];

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
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isUser = messages[index]['fromUser'] as bool;
                final text = messages[index]['text'] as String;

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
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              color: Palette.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
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
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Palette.primary,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Send message logic
                      },
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

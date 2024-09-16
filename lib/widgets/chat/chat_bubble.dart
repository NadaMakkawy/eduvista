import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;

  const ChatBubble({
    required this.isSender,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color:
            isSender ? ColorUtility.senderChatBubble : ColorUtility.deepYellow,
      ),
      child: Text(
        message,
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}

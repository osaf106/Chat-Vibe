import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget
{
  final String message;
  final bool isCurrentUser;

  const ChatBubble({super.key,required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xff58B6FA) : Colors.grey,
        borderRadius: isCurrentUser? const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ):
        const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        )
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      child: Text(message,style: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500
      ),),
    );
  }

}
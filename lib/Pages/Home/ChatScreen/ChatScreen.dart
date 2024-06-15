import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagner_app/Pages/Home/Main/HomeMainScreen.dart';
import 'package:messagner_app/Services/chat/ChatService.dart';
import 'package:messagner_app/SessionController/SessionController.dart';
import 'package:messagner_app/models/ChatBooble/ChatBobble.dart';

class ChatScreen extends StatefulWidget {
  final String receiverName;
  final String receiverID;

  ChatScreen({super.key, required this.receiverName, required this.receiverID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ChatServices chatServices = ChatServices();

  // Text Field Focues
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => ScrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => ScrollDown());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
    messageController.dispose();
  }

  // send message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      SessionController().latestMessage = messageController.text;
      await chatServices.sendMessage(
          widget.receiverID, messageController.text.trim());
      messageController.clear();
    }
    ScrollDown();
  }

  final ScrollController scrollController = ScrollController();

  void ScrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.receiverName,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xff58B6FA)),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(child: buildMessageList()),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff58B6FA)),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: messageController,
                      obscureText: false,
                      decoration: const InputDecoration(
                          hintText: 'Type a Message', border: InputBorder.none),
                    ),
                  )),
                  IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xff58B6FA),
                      ))
                ],
              ),
            ),
            //buildMessageList()
          ],
        ));
  }

  Widget buildMessageList() {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: chatServices.getMessage(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => buildMessageListItem(doc))
                .toList(),
          );
        });
  }

  Widget buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is Current User
    bool isCurrentUser =
        data["senderID"] == FirebaseAuth.instance.currentUser!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    SessionController().latestMessage = data["message"];
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
            Text(data["timestamp"].toString()),
          ],
        ));
  }
}

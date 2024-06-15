import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagner_app/Pages/Home/ChatScreen/ChatScreen.dart';
import 'package:messagner_app/Pages/Home/Drawer/drawer.dart';
import 'package:messagner_app/Pages/Home/Tiles/UserTiles.dart';
import 'package:messagner_app/Services/chat/ChatService.dart';
import 'package:messagner_app/SessionController/SessionController.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  final ChatServices chatServices = ChatServices();
  String imageGet = '';
  String nameGet = "";
  List<Map<String, dynamic>> _userData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff58B6FA),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "C H A T  V I B E",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      drawer: DrawerWidget(),
      body: buildUserList(),
    );
  }

  Widget buildUserList() {
    return StreamBuilder(
        stream: chatServices.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>((userdata) => buildUserListItem(userdata, context))
                .toList(),
          );
        });
  }

  String latestMessageIs = "";

  Widget buildUserListItem(
      Map<String, dynamic> userdata, BuildContext context) {
    if (userdata["Email"] != FirebaseAuth.instance.currentUser!.email) {
      //fetchAndSetLatestMessage(userdata['userId'],FirebaseAuth.instance.currentUser!.uid);
      return UserTiles(
        text: userdata["Email"],
        textName: userdata["Name"],
        imageUrlGet: userdata["ImageUrl"],
        latestMessage: latestMessageIs,
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiverName: userdata["Name"],
                        receiverID: userdata['userId'],
                      )));
        },
      );
    } else {
      SessionController().imageGet = userdata["ImageUrl"];
      SessionController().nameGet = userdata["Name"];
      SessionController().emailGet = userdata["Email"];
      SessionController().genderGet = userdata["Gender"];
      SessionController().usernameGet = userdata["UserName"];

      return Container();
    }
  }
  // Future<void> fetchAndSetLatestMessage(userID,otherUserID) async {
  //   Map<String, dynamic>? latestMessage = await ChatServices().fetchLatestMessage(userID, otherUserID);
  //     if (latestMessage == null) {
  //       latestMessageIs = "No messages found";
  //     } else {
  //       latestMessageIs = latestMessage['message'];
  //     }
  // }

}

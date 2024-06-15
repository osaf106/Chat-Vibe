import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagner_app/Pages/Home/Drawer/Profile/UserProfile.dart';
import 'package:messagner_app/Pages/Home/Setting/Change%20Password/Change%20Password.dart';
import 'package:messagner_app/Pages/Home/Setting/Delete%20Account/Delete%20Account.dart';
import 'package:messagner_app/SessionController/SessionController.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // String imageGet ='';
  // String nameGet ="";
  // List<Map<String, dynamic>> _userData = [];


  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getDataFromFirebase();
  // }
  // Future getDataFromFirebase() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   if(snapshot.docs.isNotEmpty)
  //     {
  //       _userData = snapshot.docs.map((doc) => doc.data()).toList();
  //       for (var user in _userData) {
  //         imageGet = user["ImageUrl"];
  //         nameGet = user["Name"];
  //       }
  //       print(imageGet);
  //       print(nameGet);
  //     }
  // }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff58B6FA),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ListView(
          children: [
            Container(
              width: 370,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xff58B6FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading:
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 12,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: SessionController().imageGet!.isEmpty
                                      ? const AssetImage(
                                      "assets/images/11591761.jpg")
                                      : NetworkImage(
                                    SessionController().imageGet!,
                                  ) as ImageProvider,
                                  fit: BoxFit.cover)),
                        ),
                        title: Text(
                          SessionController().nameGet!,
                          style: const TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        subtitle: const Text("Profile",style: TextStyle(color: Colors.white, fontSize: 15),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 370,
              height: 250,
              decoration: BoxDecoration(
                  color: const Color(0xff58B6FA),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showAboutDialog(
                          context: context,
                          applicationName: "Chat Vibe",
                          applicationVersion: "0.1.0",
                          applicationLegalese: "Developed by Osaf Ahmad Sial",
                          applicationIcon: Image.asset(
                            "assets/images/chatvibeLOGO.jpg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.launch_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        title: Text(
                          "Legal Information",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.library_books_sharp,
                          color: Colors.white,
                          size: 25,
                        ),
                        title: Text(
                          "Terms use",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 370,
              height: 200,
              decoration: BoxDecoration(
                  color: const Color(0xff58B6FA),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.key,
                          color: Colors.white,
                          size: 25,
                        ),
                        title: Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteAccount()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 25,
                        ),
                        title: Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagner_app/Pages/Home/Drawer/Profile/UserProfile.dart';
import 'package:messagner_app/Pages/Home/Main/HomeMainScreen.dart';
import 'package:messagner_app/Pages/Home/Setting/Setting.dart';
import 'package:messagner_app/Pages/login/login.dart';
import 'package:messagner_app/SessionController/SessionController.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Center(
                child: Text("C H A T \n V I B E",
                    style: TextStyle(
                        color: Color(0xff58B6FA),
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text(
                    "H o m e",
                    style: TextStyle(color: Color(0xff58B6FA)),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Color(0xff58B6FA),
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeMainScreen()));
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 25.0),
              //   child: ListTile(
              //     title: const Text(
              //       "P R O F I L E",
              //       style: TextStyle(color: Color(0xff58B6FA)),
              //     ),
              //     leading: const Icon(
              //       Icons.person,
              //       color: Color(0xff58B6FA),
              //       size: 30,
              //     ),
              //     onTap: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => UserProfile()));
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text(
                    "S E T T I N G S",
                    style: TextStyle(color: Color(0xff58B6FA)),
                  ),
                  leading: const Icon(
                    Icons.settings,
                    color: Color(0xff58B6FA),
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 35),
            child: ListTile(
              title: const Text(
                "L O G O U T",
                style: TextStyle(color: Color(0xff58B6FA)),
              ),
              leading: const Icon(
                Icons.logout,
                color: Color(0xff58B6FA),
                size: 30,
              ),
              onTap: () {
                print(FirebaseAuth.instance.currentUser!.uid);
                FirebaseAuth.instance.signOut();
                SessionController().userId = "";
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

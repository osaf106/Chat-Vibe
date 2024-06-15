// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messagner_app/Pages/Foreget%20Password/ForgetPassword.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController re_type_new_Password = TextEditingController();
  String nameGetCurrentUser = "";
  String passwordGetCurrentUser = "";
  String emailGetCurrentUser = "";
  String dateGetCurrentUser = "";
  User? currentUser = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _userData = [];
  bool isFocus = false;
  bool isFocus1 = false;
  bool isFocus2 = false;
  bool isPasswordShow = true;
  bool isPasswordShow1 = true;
  bool isPasswordShow2 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getDataFromFireBase();
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentApplicationHeight = MediaQuery.of(context).size.height;
    double currentApplicationWidth = MediaQuery.of(context).size.width;
    const LinearGradient gradient_ = LinearGradient(
      colors: [
        Color(0xFF199ADD),
        Color(0xFF14BBD4),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF199ADD),
              Color(0xFF14BBD4),
            ]),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 35, left: 20, right: 20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF199ADD),
              Color(0xFF14BBD4),
            ])),
        child: ListView(
          children: [
            Text("${nameGetCurrentUser.toString()} - Chat Vibe",
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            const SizedBox(
              height: 10,
            ),
            const Text("Change Password",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your password must be at least 6 characters and"
                  " should include a combination of numbers, letters, "
                  "and special characters",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocus = hasFocus;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: 370,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isFocus == true
                          ? Border.all(width: 1, color: Colors.black)
                          : Border.all(width: 0)),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return gradient_.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: TextFormField(
                      controller: oldPassword,
                      obscureText: isPasswordShow,
                      decoration: InputDecoration(
                        // hintText: "Current Password",
                          labelText: isFocus == true
                              ? "Current Password "
                              : "Current Password ",
                          labelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 3,
                              color: Colors.white),
                          suffixIcon: isFocus == true && isPasswordShow == true
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ))
                              : isFocus == true && isPasswordShow == false
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow = true;
                                });
                              },
                              icon: const Icon(Icons.visibility,
                                  color: Colors.white))
                              : Text(""),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocus1 = hasFocus;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: 370,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isFocus1 == true
                          ? Border.all(width: 1, color: Colors.black)
                          : Border.all(width: 0)),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return gradient_.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: TextFormField(
                      controller: newPassword,
                      obscureText: isPasswordShow1,
                      decoration: InputDecoration(
                        // hintText: "Current Password",
                          labelText: isFocus1 == true
                              ? "New Password "
                              : "New Password ",
                          labelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 3,
                              color: Colors.white),
                          suffixIcon:
                          isFocus1 == true && isPasswordShow1 == true
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow1 = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ))
                              : isFocus1 == true && isPasswordShow1 == false
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow1 = true;
                                });
                              },
                              icon: const Icon(Icons.visibility,
                                  color: Colors.white))
                              : Text(""),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocus2 = hasFocus;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: 370,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isFocus2 == true
                          ? Border.all(width: 1, color: Colors.black)
                          : Border.all(width: 0)),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return gradient_.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: TextFormField(
                      controller: re_type_new_Password,
                      obscureText: isPasswordShow2,
                      decoration: InputDecoration(
                        // hintText: "Current Password",
                          labelText: isFocus2 == true
                              ? "Re-type new Password "
                              : "Re-type new Password ",
                          labelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 3,
                              color: Colors.white),
                          suffixIcon:
                          isFocus2 == true && isPasswordShow2 == true
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow2 = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ))
                              : isFocus2 == true && isPasswordShow2 == false
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShow2 = true;
                                });
                              },
                              icon: const Icon(Icons.visibility,
                                  color: Colors.white))
                              : Text(""),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()));
                },
                child: const Text(
                  "Forgot your Password?",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                )),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                changePasswordByCurrentPassword();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  width: 350,
                  height: currentApplicationHeight > 700
                      ? 60
                      : currentApplicationHeight > 600
                      ? 50
                      : 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return gradient_.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                        },
                        child: Text(
                          "Password Change",
                          style: TextStyle(
                              fontSize: currentApplicationWidth > 370 &&
                                  currentApplicationHeight > 70
                                  ? 23
                                  : currentApplicationWidth > 370 &&
                                  currentApplicationHeight > 70
                                  ? 20
                                  : 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDataFromFireBase() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .where("userId", isEqualTo: currentUser?.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _userData = querySnapshot.docs.map((e) => e.data()).toList();
        for (var data in _userData) {
          nameGetCurrentUser = data["Name"];
          passwordGetCurrentUser = data["Password"];
          emailGetCurrentUser = data["Email"];
          //dateGetCurrentUser = data["createdAt"];
        }
      });
    }
  }

  Future<void> changePasswordByCurrentPassword() async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);
    if (oldPassword.text.trim().isNotEmpty &&
        newPassword.text.trim().isNotEmpty &&
        re_type_new_Password.text.trim().isNotEmpty) {
      if (oldPassword.text.trim().length > 5 &&
          newPassword.text.trim().length > 5 &&
          re_type_new_Password.text.trim().length > 5) {
        if (oldPassword.text == passwordGetCurrentUser) {
          if (newPassword.text == re_type_new_Password.text) {
            var cred = EmailAuthProvider.credential(
                email: emailGetCurrentUser, password: oldPassword.text.trim());
            if (currentUser != null) {
              await currentUser!
                  .reauthenticateWithCredential(cred)
                  .then((value) => {
                currentUser!.updatePassword(newPassword.text),
                documentReference.update({
                  "Password": newPassword.text,
                }),
              })
                  .catchError((error) {
                Fluttertoast.showToast(
                    msg: "There are problem in New password",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 15.0);
              });
            }

            await Fluttertoast.showToast(
                msg: "Successfully Changed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 15.0);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(
                msg: "new password not match",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Old Password not match",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Password Must be in 6 Characters",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Fill the each Field",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }
}

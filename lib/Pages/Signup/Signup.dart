import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_info/d_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagner_app/Pages/login/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messagner_app/SessionController/SessionController.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(alignment: Alignment.center, children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color(0xff58B6FA),
          child: const Padding(
            padding: EdgeInsets.only(top: 90.0, left: 40),
            child: Text(
              "Welcome to \n ChatVibe",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color(0xff58B6FA)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff58B6FA)),
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Color(0xff58B6FA),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          label: Text(
                            "Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff58B6FA)),
                          ),
                          suffixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xff58B6FA),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text(
                            "Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff58B6FA)),
                          ),
                          suffixIcon: Icon(
                            Icons.key,
                            color: Color(0xff58B6FA),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text(
                            "Confirm Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff58B6FA)),
                          ),
                          suffixIcon: Icon(
                            Icons.key,
                            color: Color(0xff58B6FA),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      registerToTheFirebase();
                    },
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xff58B6FA),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Already Have Account",
                      style: TextStyle(color: Color(0xff58B6FA)),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Sign in",
                        style:
                            TextStyle(color: Color(0xff58B6FA), fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
                semanticsValue: 'Loading',
                semanticsLabel: 'Loading',
                // backgroundColor: Colors.grey,
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
          )
      ]),
    );
  }

  bool _isValidEmail(String email) {
    // Simple email validation using a regular expression.
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isLoading = false;

  void createLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void endLoading() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> registerToTheFirebase() async {
    createLoading();
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text.length > 5 &&
          confirmPasswordController.text.length > 5) {
        if (_isValidEmail(emailController.text)) {
          if (passwordController.text == confirmPasswordController.text) {
            if (RegExp(r'[a-zA-Z]').hasMatch(nameController.text.trim())) {
              try {
                String userReplace = emailController.text.replaceAll("@gmail.com", "");
                String upDateUserName = userReplace.replaceFirst(userReplace[0], userReplace[0].toUpperCase());
                String firstNameLetter = userReplace.substring(0,1).toUpperCase();
                createLoading();
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                if (userCredential != null) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userCredential.user!.uid)
                      .set({
                    "createdAt": DateTime.now(),
                    "Name": nameController.text.trim(),
                    "Email": emailController.text.trim(),
                    "UserName":upDateUserName.toUpperCase(),
                    "Password": passwordController.text.trim(),
                    "ConfirmPassword": confirmPasswordController.text.trim(),
                    "userId": FirebaseAuth.instance.currentUser!.uid,
                    "SearchKey": firstNameLetter,
                    "Gender": "",
                    "ImageUrl": ""
                  });
                  SessionController().userId =
                      FirebaseAuth.instance.currentUser!.uid;
                  endLoading();
                  DInfo.dialogSuccess(context, 'Register Successfully');
                  DInfo.closeDialog(context,
                      durationBeforeClose: const Duration(seconds: 3),
                      actionAfterClose: () {
                    endLoading();
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    });
                  });
                } else {
                  Fluttertoast.showToast(
                      msg:
                          "Unable to connect to the internet. Please check your network connection and try again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  endLoading();
                  //throw Exception();
                }
              } catch (e) {
                if (e is FirebaseException && e.code == 'failed-precondition') {
                  // If the error is related to network issues
                  Fluttertoast.showToast(
                      msg:
                          "Unable to connect to the internet. Please check your network connection and try again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  endLoading();
                }
                if (e is FirebaseException &&
                    e.code == 'network-request-failed') {
                  Fluttertoast.showToast(
                      msg:
                          "No internet connection. Please check your network settings.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  endLoading();
                }
                if (e is FirebaseException &&
                    e.code == 'email-already-in-use') {
                  // User already exists, handle accordingly
                  Fluttertoast.showToast(
                      msg: "Email already in use. Try logging in instead.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  endLoading();
                }
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Name must be in alphabets",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 15.0);
              endLoading();
            }
          } else {
            Fluttertoast.showToast(
                msg: "Password not Match",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0);
            endLoading();
          }
        } else {
          Fluttertoast.showToast(
              msg: "Email Pattern is Incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
          endLoading();
        }
      }
      else
        {
          Fluttertoast.showToast(
              msg: "Password must be in 6 characters",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
          endLoading();
        }
    } else {
      Fluttertoast.showToast(
          msg: "Please Fill the Each Field",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
      endLoading();
    }
  }
}

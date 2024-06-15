import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_info/d_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messagner_app/Pages/Foreget%20Password/ForgetPassword.dart';
import 'package:messagner_app/Pages/Home/Main/HomeMainScreen.dart';
import 'package:messagner_app/Pages/Signup/Signup.dart';

import '../../SessionController/SessionController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
          children: [
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
                    "Sign in",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color(0xff58B6FA)),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: const Text(
                        "Forget Password",
                        style: TextStyle(color: Color(0xff58B6FA)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      loginInChatVibe();
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
                        "Sign in",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Don't Have Account",
                      style: TextStyle(color: Color(0xff58B6FA)),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: const Text(
                        "Sign up",
                        style:
                            TextStyle(color: Color(0xff58B6FA), fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
        ),
        if(isLoading)
          const Center(
            child:
            CircularProgressIndicator(
                semanticsValue: 'Loading',
                semanticsLabel: 'Loading',
                // backgroundColor: Colors.grey,
                strokeWidth: 4,
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _userData = [];
  String passwordCheck = "";
  late DocumentReference documentReference;
  Future<void> loginInChatVibe() async {
    createLoading();
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (_isValidEmail(emailController.text)) {
        if (passwordController.text.length > 5) {
          try {
            UserCredential user = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text);
            if(user!=null)
              {
                documentReference = FirebaseFirestore.instance
                    .collection("users")
                    .doc(_auth.currentUser!.uid);
                QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
                    .instance
                    .collection("users")
                    .where("userId", isEqualTo: _auth.currentUser!.uid)
                    .get();
                if (querySnapshot.docs.isNotEmpty) {
                  _userData = querySnapshot.docs.map((e) => e.data()).toList();
                  for (var data in _userData) {
                    passwordCheck = data["Password"];
                    //dateGetCurrentUser = data["createdAt"];
                  }
                }
                if (passwordCheck != passwordController.text && passwordCheck.isNotEmpty && passwordCheck.length > 5) {
                  documentReference.update({"Password": passwordController.text});
                }
                //final currentuser = _authinstance.currentUser;
                SessionController().userId = FirebaseAuth.instance.currentUser!.uid.toString();
                //SessionController().userId = currentuser!.uid.toString();
                endLoading();
                DInfo.dialogSuccess(context, 'Login Successfully');
                //DInfo.notifSuccess("Sucess", "Check your Email");
                endLoading();
                DInfo.closeDialog(context,
                    durationBeforeClose: const Duration(seconds: 3),
                    actionAfterClose: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeMainScreen()));
                    });
              }
            else {
              Fluttertoast.showToast(
                  msg: "Wrong Email or Password, try again!",
                  // msg: "Unable to connect to the internet. Please check your network connection and try again.!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 15.0);
              endLoading();
            }
          }on FirebaseAuthException catch(e){
            if (e.code == 'failed-precondition') {
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
            if (e.code == 'user-not-found') {

              Fluttertoast.showToast(
                  msg:
                  "User not Found",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 15.0);
              endLoading();
            }
            if (e.code == 'network-request-failed') {
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
          }
        } else {
          Fluttertoast.showToast(
              msg: "Password length must be in 6 Characters",
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

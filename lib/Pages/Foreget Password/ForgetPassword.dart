import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messagner_app/Pages/login/login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

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
                    "Forget Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color(0xff58B6FA)),
                  ),
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      forgetPassword();
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
                        "Reset Password",
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
                      "Already Know Password",
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

  Future<void> forgetPassword() async {
    createLoading();
    try {
      if (emailController.text.trim().isNotEmpty) {
        if (_isValidEmail(emailController.text.trim()) == true) {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(
              email: emailController.text,
            );
            Fluttertoast.showToast(
                msg: "Reset password link send to your Mail",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 15.0);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            endLoading();
          } on FirebaseAuthException catch (e) {
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
            if (e.code == 'user-not-found') {
              Fluttertoast.showToast(
                  msg: "Email Doesn't Exits",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 15.0);
              endLoading();
            }
            print("Exception by Osaf ${e}");
          }
        } else {
          await Fluttertoast.showToast(
              msg: "Email Pattern not Match",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          endLoading();
        }
      } else {
        await Fluttertoast.showToast(
            msg: "Please Fill the Email Field",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        endLoading();
      }
    } catch (e) {
      print("OSaf Exp ${e}");
    }
  }
}

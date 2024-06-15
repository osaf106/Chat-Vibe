import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:messagner_app/Pages/Home/Main/HomeMainScreen.dart';
import 'package:messagner_app/Pages/login/login.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen(
        useImmersiveMode: true,
        duration: const Duration(milliseconds: 3000),
        nextScreen:  FirebaseAuth.instance.currentUser == null ? const LoginScreen(): HomeMainScreen(),
        backgroundColor: Colors.white,
        splashScreenBody: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/splash/applogo.json",
                repeat: false,
              ),
             const SizedBox(height: 15,),
              LoadingAnimationWidget.newtonCradle(
                size: 60, color: const Color(0xff14BDD4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

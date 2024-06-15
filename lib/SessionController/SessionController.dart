
import 'dart:io';

class SessionController
{
  static final SessionController sessionController = SessionController._internal();

  String? userId;
  String? imageGet;
  String? nameGet;
  String? emailGet;
  String? usernameGet;
  String? genderGet;
  String? latestMessage;
  factory SessionController(){
    return sessionController;
  }

  SessionController._internal();
}
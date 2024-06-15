import 'package:flutter/material.dart';
import 'package:messagner_app/SessionController/SessionController.dart';

class UserTiles extends StatelessWidget {
  final String text;
  final String textName;
  final String imageUrlGet;
  final String latestMessage;
  final void Function()? ontap;

  const UserTiles({
    super.key,
    required this.text,
    required this.textName,
    required this.ontap,
    required this.imageUrlGet,
    required this.latestMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff58B6FA),
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: Container(
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: imageUrlGet.isEmpty
                        ? const AssetImage("assets/images/11591761.jpg")
                        : NetworkImage(
                            imageUrlGet,
                          ) as ImageProvider,
                    fit: BoxFit.cover)),
          ),
          title: Text(
            textName,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            latestMessage.isNotEmpty ? latestMessage : text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

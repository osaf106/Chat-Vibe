import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messagner_app/Pages/login/login.dart';
import 'package:messagner_app/SessionController/SessionController.dart';
class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool isFocus = false;
  bool showPassword = true;
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void loadingStart() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingEnd() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentApplicationWidth = MediaQuery.of(context).size.width;
    double currentApplicationHeight = MediaQuery.of(context).size.height;
    const LinearGradient gradient_ = LinearGradient(
      colors: [
        Color(0xFF199ADD),
        Color(0xFF14BBD4),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF199ADD),
              Color(0xFF14BBD4),
            ]),
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF199ADD),
                Color(0xFF14BBD4),
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delete Account",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "To delete your account, you'll need to provide"
                    " your password as a security measure during the"
                    " deletion process. This ensures authorized access "
                    "and prevents accidental or unauthorized account removal.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                textAlign: TextAlign.justify,
              ),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocus = hasFocus;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    width: 360,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isFocus == true
                            ? Border.all(width: 1, color: Colors.grey)
                            : Border.all(
                          width: 0,
                        )),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return gradient_.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                      },
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Enter Your Password",
                            labelStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                wordSpacing: 3,
                                color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.white,
                            ),
                            suffixIcon: isFocus == true && showPassword == true
                                ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPassword = false;
                                });
                              },
                              child: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            )
                                : isFocus == true && showPassword == false
                                ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPassword = true;
                                });
                              },
                              child: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ),
                            )
                                : Text("")),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  deleteAccount();
                },
                child: Container(
                  width: 380,
                  height: currentApplicationHeight > 700
                      ? 60
                      : currentApplicationHeight > 600
                      ? 50
                      : 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return gradient_.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Color(0xFF14BDD4),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                    fontSize: currentApplicationWidth > 370 &&
                                        currentApplicationHeight > 70
                                        ? 23
                                        : currentApplicationWidth > 370 &&
                                        currentApplicationHeight > 70
                                        ? 20
                                        : 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ]),
                      )),
                ),
              ),
            ],
          )),
    );
  }

  List<Map<String, dynamic>> _userData = [];
  String passwordGetCurrentUser = "";

  Future<void> deleteAccount() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .where("userId", isEqualTo: SessionController().userId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      _userData = querySnapshot.docs.map((e) => e.data()).toList();
      setState(() {
        for (var data in _userData) {
          passwordGetCurrentUser = data["Password"];
        }
      });
    }

    if (passwordController.text.isNotEmpty) {
      if (passwordController.text.length > 5) {
        if (passwordController.text == passwordGetCurrentUser) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Account Delete"),
                  content: const Text('Press ok to delete your Account'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          loadingStart();
                          String? imageDPURL = await getImageUrl();
                          // History Images Delete
                          setState(() {
                            getHistoryImageUrlAndDeleteItOnStorage();
                          });
                          //DPImagesDelete
                          if (imageDPURL.toString().isNotEmpty) {
                            String imageDP = imageDPURL.toString();
                            await FirebaseStorage.instance
                                .refFromURL(imageDP)
                                .delete();
                          }

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(SessionController().userId)
                              .delete();
                          deleteHistoryImageUrl();

                          User? firBaseCurrentUser =
                              FirebaseAuth.instance.currentUser;
                          SessionController().userId = "";
                          if (firBaseCurrentUser != null) {
                            try {
                              AuthCredential credential =
                              EmailAuthProvider.credential(
                                  email:
                                  firBaseCurrentUser.email.toString(),
                                  password: passwordGetCurrentUser);
                              await firBaseCurrentUser
                                  .reauthenticateWithCredential(credential);
                              await firBaseCurrentUser.delete();
                            } catch (e) {
                              print("Exception of Delete Account ${e}");
                            }
                          }
                          // return to login screen
                          // ignore: use_build_context_synchronously
                          if (SessionController().userId.toString().isEmpty) {
                            // ignore: use_build_context_synchronously
                            loadingEnd();
                            Fluttertoast.showToast(
                                msg: "Account Successfully Deleted",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 15.0);
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          }
                        },
                        child: const Text("Ok"))
                  ],
                );
              });
        } else {
          Fluttertoast.showToast(
              msg: "Password not match",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Password must be at least 6 characters",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Fill the password Field",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  Future<String?> getImageUrl() async {
    String currentUserId = SessionController().userId.toString();
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    if (userSnapshot.exists) {
      return userSnapshot.data()?['ImageUrl'];
    }
    return null;
  }

  Future<void> getHistoryImageUrlAndDeleteItOnStorage() async {
    String currentUserId = SessionController().userId.toString();
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);

    // Reference to the "History" subcollection
    CollectionReference historyCollectionRef = userDocRef.collection('History');

    // Check if the "History" subcollection exists
    QuerySnapshot historyQuerySnapshot = await historyCollectionRef.limit(1).get();

    if (historyQuerySnapshot.docs.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUserId)
          .collection("History")
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> index
      in userSnapshot.docs) {
        String deleteImageOnStorageURL = index.data()['HistoryImageUrl'];
        if (deleteImageOnStorageURL.isNotEmpty) {
          await FirebaseStorage.instance
              .refFromURL(deleteImageOnStorageURL)
              .delete();
        }
      }
    }
  }

  Future<void> deleteHistoryImageUrl() async {
    QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(
        SessionController().userId)
        .collection("History")
        .limit(1)
        .get();
    if (subCollectionSnapshot.docs.isNotEmpty) {
      subCollectionSnapshot.docs.forEach((element) async {
        await element.reference.delete();
      });
    }
    // ignore: avoid_function_literals_in_foreach_calls
  }
}

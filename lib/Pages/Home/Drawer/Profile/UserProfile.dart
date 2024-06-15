
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_info/d_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messagner_app/SessionController/SessionController.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool isLoadingStart = false;
  bool isLoadingStartForUpdate = false;
  File? imageFile;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  DocumentReference userDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(SessionController().userId);

  // ignore: prefer_typing_uninitialized_variables
  String imageUrlGet = "";
  List<Map<String, dynamic>> _userData = [];

  // FireBase Data Get
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = SessionController().nameGet!;
    emailController.text = SessionController().emailGet!;
    genderController.text = SessionController().genderGet!;
    userNameController.text = SessionController().usernameGet!;
    print("Sesstion ${SessionController().userId}");
    print("Current ${FirebaseAuth.instance.currentUser!.uid}");
  }
  @override
  // bool showPassword = true;
   bool isEnableTextFieldEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
          child: GestureDetector(
              onTap: () {
                Focus.of(context).unfocus();
              },
              child: Stack(
                children: [
                  ListView(
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6D6D6D)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: bottomSheet,
                              child:
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 12,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10))
                                    ],
                                    border: Border.all(
                                      width: 4,
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
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEnableTextFieldEditing =
                                      !isEnableTextFieldEditing;
                                      //fetchData();
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF199ADD),
                                          Color(0xFF14BAD5),
                                        ]),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(nameController, "Full Name", false,
                          isEnableTextFieldEditing),
                      buildTextField(emailController, "Email", false,
                          isEnableTextFieldEditing),
                      buildTextField(userNameController, "User Name", false,
                          isEnableTextFieldEditing),
                      buildTextField(genderController, "Gender", false,
                          isEnableTextFieldEditing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEnableTextFieldEditing = false;
                              });
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20),
                              child: Container(
                                width: 100,
                                height: 60,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFF199ADD),
                                      Color(0xFF14BAD5),
                                    ]),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isEnableTextFieldEditing == true) {
                                setState(() {
                                  updateData();
                                  isEnableTextFieldEditing = false;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Already Changed",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 15.0);
                              }
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20),
                              child: Container(
                                width: 100,
                                height: 60,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFF199ADD),
                                      Color(0xFF14BAD5),
                                    ]),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Center(
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isLoadingStartForUpdate == true)
                    const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.blueAccent,
                        ))
                ],
              )),
        ));
  }

  Widget buildTextField(
      TextEditingController controllerOfTextField,
      String labelTextShow,
      bool isPasswordField,
      bool checkEnableTextFieldEditing) {
    const LinearGradient gradient_ = LinearGradient(
      colors: [
        Color(0xFF199ADD),
        Color(0xFF14BBD4),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        enabled: checkEnableTextFieldEditing,
        controller: controllerOfTextField,
        decoration: InputDecoration(
            prefixIcon: labelTextShow == "Full Name"
                ? ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height));
              },
              child: const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
                : labelTextShow == "Email"
                ? ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height));
              },
              child: const Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
                : labelTextShow == "User Name"
                ? ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(Rect.fromLTWH(
                    0, 0, bounds.width, bounds.height));
              },
              child: const Icon(
                Icons.verified_user,
                color: Colors.white,
                size: 30,
              ),
            )
                : labelTextShow == "Gender"
                ? controllerOfTextField.text == "Male" ||
                controllerOfTextField.text == "male"
                ? ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(
                    Rect.fromLTWH(0, 0, bounds.width,
                        bounds.height));
              },
              child: const Icon(
                Icons.male_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
                : controllerOfTextField.text == "Female" ||
                controllerOfTextField.text == "female"
                ? ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(
                    Rect.fromLTWH(0, 0, bounds.width,
                        bounds.height));
              },
              child: const Icon(
                Icons.female_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
                : ShaderMask(
              shaderCallback: (bounds) {
                return gradient_.createShader(
                    Rect.fromLTWH(0, 0, bounds.width,
                        bounds.height));
              },
              child: const Icon(
                Icons.transgender_outlined,
                color: Colors.white,
                size: 30,
              ),
            )
                : labelTextShow == "Password"
                ? const Icon(
              Icons.key_outlined,
              color: Colors.blueAccent,
              size: 30,
            )
                : const Icon(
              Icons.account_circle_outlined,
              color: Colors.blueAccent,
              size: 30,
            ),
            labelText: labelTextShow,
            contentPadding: const EdgeInsets.only(bottom: 3),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusColor: Colors.blueAccent),
      ),
    );
  }

  User? currentUser = FirebaseAuth.instance.currentUser;

  // Future<void> fetchData() async {
  //   setState(() {
  //     isLoadingStart = true;
  //   });
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("userId", isEqualTo: currentUser?.uid)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       setState(() {
  //         _userData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //         for (var user in _userData) {
  //           nameController.text = user["Name"];
  //           emailController.text = user["Email"];
  //           passwordController.text = user["Password"];
  //           userNameController.text = user['UserName'];
  //           genderController.text = user['Gender'];
  //           imageUrlGet = user["ImageUrl"];
  //         }
  //         if (emailController.text.trim() != currentUser?.email.toString()) {
  //           emailController.text = currentUser!.email.toString();
  //           print(currentUser?.email.toString());
  //           updateChanges();
  //         }
  //         print(currentUser?.email.toString());
  //         print(imageUrlGet);
  //       });
  //     } else {
  //       _userData.clear();
  //     }
  //     setState(() {
  //       isLoadingStart = false;
  //     });
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     DInfo.dialogError(context, 'Exception ${e}');
  //   }
  // }

  Future<void> updateChanges() async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);
      await documentReference.update({
        "Email": emailController.text,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData() async {
    setState(() {
      isLoadingStartForUpdate = true;
    });
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);

    if (currentUser != null) {
      try {
        await currentUser!.verifyBeforeUpdateEmail(emailController.text);
        AuthCredential authCredential = EmailAuthProvider.credential(
            email: currentUser!.email!, password: passwordController.text);
        await currentUser!.reauthenticateWithCredential(authCredential);
        await currentUser!.updateEmail(emailController.text);

        print(currentUser!.email.toString());
        Fluttertoast.showToast(
            msg: "Login Again Because to Have Change Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
      } catch (e) {
        print("Osaf Exceptoion ${e}");
      }
    }

    await documentReference.update({
      "Name": nameController.text,
      "Email": emailController.text,
      "UserName": userNameController.text,
      //"Password": passwordController.text,
      "Gender": genderController.text,
      //"ImageUrl": imageUrlGet
    });
    setState(() {
      isLoadingStartForUpdate = false;
    });
    // ignore: use_build_context_synchronously
    DInfo.dialogSuccess(context, 'Update Successfully');
    // ignore: use_build_context_synchronously
    DInfo.closeDialog(
      context,
      durationBeforeClose: const Duration(seconds: 3),
    );
  }

  void bottomSheet() {
    double currentApplicationWidth = MediaQuery.of(context).size.width;
    // double currentApplicationHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bContext) {
          return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(colors: [
                    Color(0xff199ADD),
                    Color(0xff14BAD5),
                  ])),
              height: 120,
              width: currentApplicationWidth,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{
                      // var cameraStatus = await Permission.camera.request();
                      // if (cameraStatus.isGranted) {
                      //   imageloadThroughCamera();
                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg: "Required Camera Permission",
                      //       toastLength: Toast.LENGTH_LONG,
                      //       gravity: ToastGravity.BOTTOM,
                      //       backgroundColor: Colors.red,
                      //       textColor: Colors.white,
                      //       fontSize: 15.0);
                      // }
                      imageloadThroughCamera();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.white, // Border color
                              width: 1.0,
                            ),
                            // Border width
                          )),
                      width: currentApplicationWidth / 2,
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 28.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      // var galleryStatus = await Permission.photos.request();
                      // if (galleryStatus.isGranted) {
                        imageloadThroughGallery();
                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg: "Required gallery Permission",
                      //       toastLength: Toast.LENGTH_LONG,
                      //       gravity: ToastGravity.BOTTOM,
                      //       backgroundColor: Colors.red,
                      //       textColor: Colors.white,
                      //       fontSize: 15.0);
                      // }
                     // imageloadThroughGallery();
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: currentApplicationWidth / 2,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }
  Future imageloadThroughCamera() async {
    final returnCameraImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(returnCameraImage!.path);
      storeImageOnFireBaseStorage();
    });
  }

  Future imageloadThroughGallery() async {
    final returnCameraImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(returnCameraImage!.path);
      storeImageOnFireBaseStorage();
    });
  }
  Future storeImageOnFireBaseStorage() async {
    setState(() {
      isLoadingStart = true;
    });
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(SessionController().userId)
        .get();
    if (userSnapshot.exists) {
      String haveAlreadyImage = userSnapshot.data()?['ImageUrl'];
      if (haveAlreadyImage.isNotEmpty) {
        FirebaseStorage.instance.refFromURL(haveAlreadyImage).delete();
      }
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("images");

    // Create Reference of Image
    Reference referenceUploadImages = referenceDirImages.child(uniqueFileName);
    // Upload Image
    if (imageFile == null) {
      return;
    }
    try {
      await referenceUploadImages.putFile(imageFile!);
      // downloadURL
      imageUrl = await referenceUploadImages.getDownloadURL();
      print(imageUrl);
      Map<String, dynamic> data = {
        "ImageUrl": imageUrl,
      };

      userDoc.update(data).then((_) {

        print("Suceess fully upload");

        SessionController().imageGet = imageUrl;
      // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => Fluttertoast.showToast(
          msg:
          "Fail to get URL",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0));
      //print(getImageUrl());
      setState(() {
        isLoadingStart = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg:
          "Fail to Upload",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }
}

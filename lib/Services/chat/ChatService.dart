import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messagner_app/models/message.dart';

class ChatServices {
  // Get Instance of FireStore and Auth
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseFireAuth = FirebaseAuth.instance;

  // get User Stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return firebaseFirestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Send Message
  Future<void> sendMessage(String receiverID, message) async {
    // get Current User Info
    final String currentUserId = firebaseFireAuth.currentUser!.uid;
    final String currentUserEmail = firebaseFireAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create A new Message
    Message newMessage = Message(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        message: message,
        receiverID: receiverID,
        timestamp: timestamp);

    // Construct chat room if for the users

    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomsID = ids.join('_');

    // ass new message ing databse
    await firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomsID)
        .collection("messages")
        .add(newMessage.toMap());
  }

// Get Message

  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');

    return firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
  Future<Map<String, dynamic>?> fetchLatestMessage(String userID, String otherUserID) async {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>?;
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/helpers/app_utils.dart';

class DatabaseService {
  Future addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      AppUtils.showToast(e.message);
      print(e.toString());
    });
  }

  Future<dynamic> getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      AppUtils.showToast(e.message);
      print(e.toString());
    });
  }

  Future<dynamic> searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  addMessage(Map chatMessageData) async {
    var docId = await FirebaseFirestore.instance
        .collection("chatMessages")
        .add(chatMessageData)
        .catchError((e) {
      AppUtils.showToast(e.message);
      print(e.toString());
    });
    print('Created record: $docId');
  }

  getChatMessages() async {
    return FirebaseFirestore.instance
        .collection("chatMessages")
        .orderBy('time')
        .snapshots();
  }
}

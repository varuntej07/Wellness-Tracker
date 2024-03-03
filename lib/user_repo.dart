import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../Models/user_model.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    print("Attempting to create user in Firestore with data: ${user.toJson()}");
    try {
      await _db.collection("UserData").doc(userUid).set({
        ...user.toJson(),
        'uid': userUid,
      });
      print("User created successfully.");
    } catch (e) {
      print("Failed to add user: $e");
    }
  }
}
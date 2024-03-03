import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:homework1/Models/user_model.dart';
import '/user_repo.dart';

class SignupController{

  static SignupController get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signup(String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email:email, password:password);
      print("Signup successful for email: $email");
      return credential.user;
    }catch(e){
      print("Signup error: $e");
      return null;
    }
  }

  Future<void> createUser(UserModel userData) async {
    try {
      final userRepo = UserRepo();
      await userRepo.createUser(userData);
      print("User data stored for: ${userData.email}");
    } catch(e){
      print("Error storing user data: $e");
    }
  }
}
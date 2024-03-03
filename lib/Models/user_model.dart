
class UserModel{

  final String username;
  final String email;
  final String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password
  });

  toJson(){
    return{
      'username': username,
      'email': email,
      'password': password
    };
  }
}

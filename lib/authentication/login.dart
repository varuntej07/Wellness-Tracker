import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home_page.dart';
import '../signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<bool> showConsentDialog(BuildContext context) async {
    bool? consentGiven = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // The user must tap a button.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Consent Required!"),
          content: const Text("By signing up, you agree to share your Recording Points with other users."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Disagree'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Agree'),
            ),
          ],
        );
      },
    );
    return consentGiven ?? false;
  }

  void navigateToSignup() async {
    bool consent = await showConsentDialog(context);
    if (consent) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Signup()),
              (Route<dynamic> route) => false);
    } else {
      //Nothing
    }
  }

  @override
  Widget build(BuildContext context) {

    void login() async {
      try {
        await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // final snackBar = SnackBar(content: Text('Successfully logged in'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // On successful login, navigating to the HomePage
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
                (Route<dynamic> route) => false);
      } on FirebaseAuthException catch (e) {
        print("Caught Error: Invalid credential or other error, ${e.message}");
        // final snackBar = SnackBar(content: Text('Login Failed: ${e.message}'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Wellness Tracker",
                style: TextStyle(color: Colors.purple, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text("Login here!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                prefixIcon: const Icon(Icons.password),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: login,
              child: const Text("Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
            ),
            Text("Forgot Password",
                style: TextStyle(fontSize: 12, color: Colors.indigo[400], decoration: TextDecoration.underline)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?", style: TextStyle(fontSize: 14)),
                TextButton(
                    onPressed: () => navigateToSignup(),
                    child: Text("Signup",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent[400])
                    )
                ),
              ],
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text('Skip'),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
                (Route<dynamic> route) => false,)
      ),
    );
  }
}
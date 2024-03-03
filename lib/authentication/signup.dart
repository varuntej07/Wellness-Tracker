import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homework1/home_page.dart';
import 'signup_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignupController _auth = SignupController();

  void signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      // If form is not valid, shouldn't proceed.
      return;
    }
    try {
      final User? user = await _auth.signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Center(
                    child: Text("Welcome to Wellness Tracker",
                        style: TextStyle(color: Colors.purple, fontSize: 26, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 30),
                const Center(
                    child: Text("Create your account and start ya journey",
                        style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold)
                    )
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Create username',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Create password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    prefixIcon: const Icon(Icons.password),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      signup();
                    }
                  },
                  child: const Center(child: Text('Save Profile')),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text('Skip'),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
                  (Route<dynamic> route) => false)
      ),
    );
  }
}
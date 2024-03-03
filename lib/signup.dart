import 'package:flutter/material.dart';
import 'package:homework1/home_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Create an Account', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Center(
                    child: Text("SignUp",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                ),
                TextFormField(
                  controller: usernameController,
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
                  controller: passwordController,
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
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyHomePage()));
                    },
                  child: const Center(child: Text('Save Profile')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _userNameTEC.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _userNameTEC,
                    decoration: InputDecoration(hintText: 'Enter Username'),
                  ),
                  TextField(
                    controller: _emailTEC,
                    decoration: InputDecoration(hintText: 'Enter Email'),
                  ),
                  TextField(
                    controller: _passwordTEC,
                    decoration: InputDecoration(hintText: 'Enter Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _signUp(context),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp(BuildContext context) async {
    if (_userNameTEC.text.isEmpty) {
      _showErrorDialog(context, 'Please enter a username.');
      return;
    }
    if (_emailTEC.text.isEmpty || !_emailTEC.text.contains('@')) {
      _showErrorDialog(context, 'Please enter a valid email.');
      return;
    }
    if (_passwordTEC.text.isEmpty || _passwordTEC.text.length < 6) {
      _showErrorDialog(context, 'Password must be at least 6 characters long.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Move the async logic to a separate method to avoid using BuildContext across async gaps.
    bool isSuccess = await _createUser();

    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      _navigateToHome(context);
    } else {
      _showErrorDialog(context, 'Sign Up Failed. Try Again.');
    }
  }

  Future<bool> _createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailTEC.text, password: _passwordTEC.text);

      User? user = userCredential.user;

      if (user != null) {
        // Get the user's UID
        String uid = user.uid;

        // Create a document in Firestore with the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': _userNameTEC.text,
          'email': _emailTEC.text,
        });
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Up Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

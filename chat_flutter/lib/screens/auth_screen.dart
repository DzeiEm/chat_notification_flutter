import 'package:flutter/material.dart';
import 'package:chat_flutter/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = true;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    var authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      var message = 'error appeared, check credentials';

      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}

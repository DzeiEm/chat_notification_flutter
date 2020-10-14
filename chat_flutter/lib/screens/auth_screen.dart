import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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

  void _submitAuthForm(String email, String username,
      File image,String password, bool isLogin, BuildContext ctx) async {
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

        //reikia irasytti image'a anksciau uz visus kitus duomenys
        //  kodel storage, nes ten yra saugomi visi image'ai ir video. Firebase saugoma tik info.
        //ref'as kreipiasi i pagrindini folderi, kuris yra susidaromas kai sukuri bucket'a
        // pirmas 'child'  susikuria folder'i ir folderio pavadinima.
        // antras child'as sukuria image'ui pavadinima, geriausias budas tai daryti peer image'o id.
        final ref = FirebaseStorage.instance
            .ref()
            .child('user-images')
            .child(authResult.user.uid + '.jpeg');
        await ref
            .putFile(image)
            .onComplete; // tai nera future, todel turim padaryti future, nes turi susiuploadinti.

        final url = await ref.getDownloadURL(); // firebase'e issaugo linka iki image'o.

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
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

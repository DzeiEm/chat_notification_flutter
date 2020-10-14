import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //reikia irasytti image'a anksciau uz visus kitus duomenys
        //  kodel storage, nes ten yra saugomi visi image'ai ir video. Firebase saugoma tik info.
        //ref'as kreipiasi i pagrindini folderi, kuris yra susidaromas kai sukuri bucket'a
        // pirmas 'child'  susikuria folder'i ir folderio pavadinima.
        // antras child'as sukuria image'ui pavadinima, geriausias budas tai daryti peer image'o id.
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(userCredential.user.uid + '.jpeg');
        await ref
            .putFile(image)
            .onComplete; // tai nera future, todel turim padaryti future, nes turi susiuploadinti.

        final url =
            await ref.getDownloadURL(); // firebase'e issaugo linka iki image'o.

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'email': email,
          'user_password': password,
          'username': username,
          'image_url': url,
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
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

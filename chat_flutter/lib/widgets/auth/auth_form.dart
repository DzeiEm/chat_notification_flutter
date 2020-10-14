import 'dart:io';

import 'package:chat_flutter/widgets/picker/user_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final Function(String email, String userName, File image, String password, bool isLogin,
      BuildContext context) submitFn;

  bool isLoading = false;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  File image;
  String _userPassword = '';
  var _isLogin = true;
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    // validacija image'ui.. 
    // jis turi buti supildytas atvejuosee, kai jis yra tuscias ir 'create new user' atveji.

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please, pick an image'),
          backgroundColor: Colors.teal,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userImageFile, _userPassword.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      // return string as an error message
                      //  null if its all okay
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(hintText: 'email'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('user name'),
                      validator: (value) {
                        if (value.length < 4) {
                          return 'Please fill in at least 4 letters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(hintText: 'user name'),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be 7 characters long';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(hintText: 'password'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(_isLogin ? 'Login' : 'Create account'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLogin ? 'Create new account' : 'Sing up'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              )),
        ),
      ),
    );
  }
}

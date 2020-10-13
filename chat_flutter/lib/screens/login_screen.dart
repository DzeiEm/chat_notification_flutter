import 'package:chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 200, left: 20, right: 20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'user name'),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'email'),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'phone'),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'password'),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'repeat password'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FlatButton(
                      color: Colors.amber,
                      child: Text('Login'),
                      onPressed: () {
                        print('login tapped');
                        Navigator.pushNamed(context, ChatScreen.routeName);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

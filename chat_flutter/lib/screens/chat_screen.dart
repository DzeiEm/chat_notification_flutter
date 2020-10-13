import 'package:chat_flutter/widgets/chat/messages.dart';
import 'package:chat_flutter/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {
  static const routeName = 'chat-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

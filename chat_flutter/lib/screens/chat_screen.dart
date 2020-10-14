import 'package:chat_flutter/widgets/chat/messages.dart';
import 'package:chat_flutter/widgets/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // ios'e mes provalome uzklausi user'io ar sutinka gauti notificationus
    // messaging package
    final firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (msg) {
      //kai appsas yra pakeltas ir yra naudojamas
      print(msg);
      return;
    }, onLaunch: (msg) {
      //kaip appsas yra uzdarytas
      print(msg);
      return;
    }, onResume: (msg) {
      //kaip appsas yra uzdarytas
      print(msg);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          DropdownButton(
            underline: Container(), // uzdedam sita tam, kad nematyti linijos chat screen'e(virsuj) prie 3u taskeliu
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

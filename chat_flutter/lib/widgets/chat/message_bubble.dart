import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  final key;
  String username;
  MessageBubble(this.message, this.username, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.purple : Colors.teal,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: !isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(username)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  }
                  return Text(
                    snapshot.data['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.cyan,
                    ),
                  );
                },
              ),
              Text(message),
            ],
          ),
        ),
      ],
    );
  }
}

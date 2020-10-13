import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnaphot) {
        if (futureSnaphot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.document;
              return ListView.builder(
                reverse: true, // nuo apacios i virsu pildosi textas
                itemCount: chatDocs.lenght,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['title'],
                  chatDocs[index]['userId'],
                  chatDocs[index]['userId'] == futureSnaphot.data.uid,
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
      },
    );
  }
}
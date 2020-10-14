import 'package:chat_flutter/screens/auth_screen.dart';
import 'package:chat_flutter/screens/chat_screen.dart';
import 'package:chat_flutter/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            // hasData - yra token'as...jei randa ta token'a reiskia user'i autentikuoja iskart
            //jei neranda - tad praso autentikuotis.
            if(userSnapshot.connectionState == ConnectionState.waiting){
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          },
        ),
        routes: {
          ChatScreen.routeName: (ctx) => ChatScreen(),
        });
  }
}

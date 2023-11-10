// import 'package:nobest_tag_app/signin_screen.dart';
// import 'package:nobest_tag_app/navigation_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nobest_tag_app/navigation_home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          return NavigationHomeScreen();
          // if (snapshot.hasData) {
          //   return NavigationHomeScreen();
          // } else {
          //   return SignInScreen();
          // }
        },
      ),
    );
  }
}

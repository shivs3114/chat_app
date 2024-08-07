import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(),
      ),
      initialRoute: 'welcomeScreen',
      routes: {
        'welcomeScreen': (context) => WelcomeScreen(),
        'LoginScreen': (context) => LoginScreen(),
        'RegistrationScreen': (context) => RegistrationScreen(),
        'ChatScreen': (context) => ChatScreen(),
      },
    );
  }
}

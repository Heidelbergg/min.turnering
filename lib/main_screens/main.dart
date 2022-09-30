import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_turnering/main_screens/navigation.dart';
import 'package:min_turnering/main_screens/splash_screen.dart';

import '../authentication/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    Widget checkHome(){
      return user == null? const SplashScreen() : const Dashboard();
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF42BEA5),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.black
        ),
      ),
      home: checkHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

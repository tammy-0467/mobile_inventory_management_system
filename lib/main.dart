import 'package:flutter/material.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/authentication_screens/widget_tree.dart';
import 'package:untitled/intro_screens/splash_screen.dart';
import 'package:untitled/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super (key: key);

      @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: appTheme,
    );
  }

}


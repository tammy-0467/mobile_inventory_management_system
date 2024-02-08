import 'package:flutter/material.dart';
import 'package:untitled/intro_screens/splash_screen.dart';
import 'package:untitled/on_boarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super (key: key);

      @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }

}


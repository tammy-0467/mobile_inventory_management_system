import 'package:untitled/authentication_screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/home_screen.dart';
import 'package:untitled/authentication_screens/login_screen.dart';
import 'package:untitled/tab_bar_screens/dashboard.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){ //if a user is signed in, the homepage is displayed
          return DashboardScreen();
        } else { //otherwise the login/register page is shown
          return const LoginPage();
        }
      },
    );
  }
}
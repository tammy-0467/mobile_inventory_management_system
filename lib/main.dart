import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/authentication_screens/widget_tree.dart';
import 'package:untitled/custom_styles/theme_manager.dart';
import 'package:untitled/intro_screens/splash_screen.dart';
import 'package:untitled/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance
  // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
    MyApp({Key? key}): super (key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//instance of the theme manager class
final ThemeManager themeManager = ThemeManager();


class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    // TODO: implement dispose
    themeManager.removeListener(() {themeListener();});
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(() {themeListener(); });
    // TODO: implement initState
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {

      });
    }
  }
      @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightAppTheme,
      darkTheme: darkAppTheme,
      themeMode: themeManager.themeMode,
    );
  }
}


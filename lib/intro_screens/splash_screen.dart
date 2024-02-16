import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/custom_styles/page_route_animation.dart';
import 'package:untitled/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //gets rid of top and botttom bars
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    //Navigate to the next screen and prevent the user from coming back to the splash screen
    Future.delayed(Duration(milliseconds: 3500), (){
      Navigator.of(context).pushReplacement(
        //call the on boarding screen through the animation screen
          BouncyPageRoute(widget: onBoardingScreen()
      ));
    }
    );
  }
  
  @override
  void dispose() {
    //brings back the top and bottom bars
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Image.asset("assets/images/splash_screen.png",
      //parameters to ensure the image covers the whole screen
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      ),

    );
  }
}

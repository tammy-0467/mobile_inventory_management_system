import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/home_screen.dart';
import 'package:untitled/intro_screens/intro_page_1.dart';
import 'package:untitled/intro_screens/intro_page_2.dart';
import 'package:untitled/login_screen.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  //keep track of page
  bool onLastPage = false;

  // controller to keep track of pages
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 1);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
          ],
        ),
        //page indicator

        Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip button
                TextButton(
                    onPressed: () {
                      _controller.jumpToPage(1);
                    },
                    child: Text("Skip")),
                //page indicator
                SmoothPageIndicator(controller: _controller, count: 2),

                //next button
                onLastPage
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => HomePage()));
                        },
                        child: Text("Done"))
                    : TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                          // Remove the _controller.nextPage() call from here
                        },
                        child: Text("Next"),
                      )
              ],
            ))
      ]),
    );
  }
}

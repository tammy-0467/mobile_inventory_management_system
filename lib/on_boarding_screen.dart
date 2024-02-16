import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/authentication_screens/widget_tree.dart';
import 'package:untitled/home_screen.dart';
import 'package:untitled/intro_screens/intro_page_1.dart';
import 'package:untitled/intro_screens/intro_page_2.dart';
import 'package:untitled/authentication_screens/login_screen.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  //keep track of the last page
  bool onLastPage = false;

  // controller to keep track of pages
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // use a stack to keep the elements on top of each other
      body: Stack(alignment: Alignment.center, children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 1);
            });
          },
          children: [
            //call the pages to be wrapped within the pageview
            IntroPage1(),
            IntroPage2(),
          ],
        ), //page indicator

        // still within the stack widget
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
                              MaterialPageRoute(builder: (_) => WidgetTree()));
                        },
                        child: Text("Done"))
                    : TextButton(
                        onPressed: () {
                          _controller.nextPage(duration: Durations.long1, curve: Curves.easeIn);
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

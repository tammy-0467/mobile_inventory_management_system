import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: SizedBox(
            height: 160,
            width: 160,
            child: Image.asset("assets/images/1086758_ONKJBH0.jpg"),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Search Items",
                style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 30))
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 2),
          child: Text("Search for inventory items",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text("to save time during",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text("sales",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}

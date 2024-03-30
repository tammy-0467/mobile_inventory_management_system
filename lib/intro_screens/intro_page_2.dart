import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
            child: Image.asset("assets/images/favpng_inventory-management-stock-taking-clip-art.png"),
          ),
        ),
         Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Stock Monitoring",
                style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 30))
        ),
         Padding(
          padding: EdgeInsets.only(top: 5, bottom: 2),
          child: Text("Track inventory levels and",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
         Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text("be aware when stock is",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
         Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text("low or high",
              style: GoogleFonts.mulish(color: Colors.grey, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}

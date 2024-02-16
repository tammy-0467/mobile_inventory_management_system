import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color COLOR_PRIMARY = Colors.lightBlue;
Color COLOR_ACCENT = Colors.blueGrey.shade700;

ThemeData appTheme = ThemeData(
    primaryColor: COLOR_PRIMARY,
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      //changing the cursor indicator within text fields
        cursorColor: COLOR_ACCENT
    ),

    //Varying text styles for different situations
    textTheme: TextTheme(
      displayLarge: GoogleFonts.oswald(
          fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: GoogleFonts.oswald(
          fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall: GoogleFonts.oswald(fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.oswald(
          fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headlineSmall: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.oswald(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleMedium: GoogleFonts.mulish(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
      titleSmall: GoogleFonts.mulish(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.mulish(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      bodyMedium: GoogleFonts.mulish(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      labelLarge: GoogleFonts.mulish(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      bodySmall: GoogleFonts.mulish(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelSmall: GoogleFonts.mulish(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    ),

    //Theme for text buttons
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 10, vertical: 10)
          ),
          //defining the shape(curved edges) of the text button
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
          foregroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT),
        )
    ),

    //Theme for elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                )
            ),
            //foreground color is the text color
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(COLOR_PRIMARY)
        )
    ),

    //Theme for text fields within the app
    inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(
          fontFamily: GoogleFonts.mulish().fontFamily,
          color: COLOR_ACCENT,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: TextStyle(
          fontFamily: GoogleFonts.mulish().fontFamily,
          color: COLOR_ACCENT,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.mulish().fontFamily,
          color: Colors.blueGrey.shade500,
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: Colors.grey.shade500.withOpacity(0.1),
        activeIndicatorBorder: BorderSide(color: COLOR_PRIMARY, width: 2)
    )
);
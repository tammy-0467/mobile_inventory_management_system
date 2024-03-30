import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/custom_styles/theme_manager.dart';

import 'authentication_screens/auth.dart';
import 'main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

final ThemeManager themeManager = ThemeManager();

class _SettingPageState extends State<SettingPage> {

  Future<void> signOut() async{
    await Auth().signOut();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.mulish(
            fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white),),
        backgroundColor: lightAppTheme.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,),
          color: Colors.white,
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            Text("ARandomUser", style: lightAppTheme.textTheme.headlineSmall,),
            Text("randomuser@gmail.com", style: lightAppTheme.textTheme.titleMedium,),
            TextButton(
                onPressed: (){},
                child: Text("Switch Profile", style: lightAppTheme.textTheme.titleMedium,)),

            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6),
                color: Colors.lightBlue
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Username",
                        style: GoogleFonts.oswald(
                            fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
                        )
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("ARandomUser",
                        style: GoogleFonts.mulish(
                            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                        )
                    ),
                    Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("User ID",
                        style: GoogleFonts.oswald(
                            fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
                        )
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("123",
                        style: GoogleFonts.mulish(
                            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                        )
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.lightBlue
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dark Theme",
                            style: GoogleFonts.oswald(
                                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
                          ),
                          Switch(
                              value: themeManager.themeMode == ThemeMode.dark,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.lightBlue,
                              trackOutlineColor: MaterialStateProperty.all(Colors.white),
                              activeColor: Colors.black,
                              onChanged: (newValue) {
                                themeManager.toggleTheme(newValue);
                              }
                          ),
                        ],
                      ),
                    Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Log Out",
                              style: GoogleFonts.oswald(
                                  fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
                            ),
                            IconButton(
                                onPressed: signOut,
                                icon: Icon(Icons.exit_to_app_outlined, color: Colors.white, size: 35,))
                          ],
                        ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

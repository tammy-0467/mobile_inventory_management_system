import 'package:flutter/material.dart';
import '../authentication_screens/auth.dart';
import 'app_theme.dart';

class MyBox extends StatelessWidget {

  const MyBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      //adds space betweeen all boxes
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey,
      ),
    );
  }
}

Future<void> signOut() async{
  await Auth().signOut();
}

class MyTile extends StatelessWidget {
  const MyTile({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      //adds space betweeen all boxes
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blueGrey,
        height: 80,
      ),
    );
  }
}

//class for the drawer used within the app
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade200,
      child: Column(
          children: [
            DrawerHeader(
                child: Image.asset("assets/images/pngwing.com.png",
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("H O M E", style: appTheme.textTheme.titleMedium,),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("S E T T I N G S", style: appTheme.textTheme.titleMedium,),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("L O G O U T", style: appTheme.textTheme.titleMedium,),
              onTap: signOut,
            ),
          ]
      ),
    );
  }
}


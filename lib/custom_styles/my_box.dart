import 'package:flutter/material.dart';
import 'package:untitled/inventory_screens/manual_data_entry.dart';
import 'package:untitled/settings_screen.dart';
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

Widget _mainText(String title){
  return Text(title, style: lightAppTheme.textTheme.titleLarge,);
}

Widget _subText(String title){
  return Text(title, style: lightAppTheme.textTheme.titleMedium);
}

Widget _subTitle(String title){
  return Text(title, style: lightAppTheme.textTheme.titleMedium,
    textAlign: TextAlign.justify,
    maxLines: 2,
    overflow: TextOverflow.clip,
    softWrap: true,
  );
}

class MyTile extends StatelessWidget {
  const MyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //adds space between all boxes
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _mainText("Item Name"),
                  _mainText("Date Added")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _subText("Number of units"),
                  _subText("Price of a unit")
                ],
              ),
            ],
          ),
        ),
        color: lightAppTheme.primaryColor,
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
                child: Image.asset("assets/images/babcock_logo.png",
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("H O M E", style: lightAppTheme.textTheme.titleMedium,),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("A D D  I T E M S", style: lightAppTheme.textTheme.titleMedium,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ManualEntryScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("S E T T I N G S", style: lightAppTheme.textTheme.titleMedium,),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> SettingPage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("L O G O U T", style: lightAppTheme.textTheme.titleMedium,),
              onTap: signOut,
            ),
          ]
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //adds space betweeen all boxes
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _mainText("Notification type"),
                    _mainText("Time")
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _subTitle("Lorem ipsum dolor sit amet, "
                          "consectetur adipiscing elit. Etiam vestibulum neque "),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        color: lightAppTheme.primaryColor,
        height: 80,
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}


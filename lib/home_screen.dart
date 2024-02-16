import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/authentication_screens/auth.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/custom_styles/my_box.dart';
import 'package:untitled/tab_bar_screens/barcode_scan_screen.dart';
import 'package:untitled/tab_bar_screens/dashboard.dart';
import 'package:untitled/tab_bar_screens/inventory_items.dart';
import 'package:untitled/tab_bar_screens/notifications_screen.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key}) :super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String appBarTxt = 'Welcome ${user?.email}';

  final User? user = Auth().currentUser;
 //instance of the auth class which checks for the current user
  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _title(){
    return Text('Welcome', style: appTheme.textTheme.headlineMedium,);
  }

  Widget _userUid(){
    //I'm assuming if the mail is null it displays user email
    return Text(user?.email ?? 'User email', style: appTheme.textTheme.bodyLarge,);
  }

  //a sign out button that calls the sign out function when called
  Widget _signOutButton(){
    return ElevatedButton(
        onPressed: signOut,
        child: const Text('Sign Out'));
  }

  //creating an index for navigating through pages on the tab bar
  int _selectedindex = 0;

  //list of screens to be used for page navigation
  final List<Widget> _screens = [
    const DashboardScreen(),
    NotificationPage(),
    BarcodeScreen(),
    InventoryScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //the appbar calls two functions which displays the welcome text and their email below it
            children: [
              _title(),
              _userUid()
            ],
          ),
        ),
        drawer: MyDrawer(),

        //call the screens function with the selected index at 0 so the first page is the dashboard screen
        body: _screens[_selectedindex],

        //a google bottom navigation bar
        bottomNavigationBar:  Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              hoverColor: Colors.grey,
              activeColor: appTheme.primaryColor,
              tabBackgroundColor: Colors.black,
              gap: 10,
              padding: EdgeInsets.all(15),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.message_outlined,
                  text: 'Inbox',
                ),
                GButton(
                  icon: Icons.barcode_reader,
                  text: 'Scan barcode',
                ),
                GButton(
                  icon: Icons.list_outlined,
                  text: 'Inventory',
                ),
              ],
              //assign the value of the selected index of the nav bar to the selected index variable
              selectedIndex: _selectedindex,
              //
              onTabChange: (index){
               setState((){
                 _selectedindex = index;
               });
              },
            ),
          ),
        )
    );
  }
}

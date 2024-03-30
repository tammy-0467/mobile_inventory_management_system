import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/authentication_screens/auth.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/custom_styles/my_box.dart';
import 'package:untitled/inventory_screens/cart_screen.dart';
import 'package:untitled/settings_screen.dart';
import 'package:untitled/tab_bar_screens/barcode_reg_screen.dart';
import 'package:untitled/tab_bar_screens/dashboard.dart';
import 'package:untitled/tab_bar_screens/inventory_items.dart';
import 'package:untitled/tab_bar_screens/notifications_screen.dart';

import 'custom_styles/drawer_file.dart';
import 'model/cart_model.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key}) :super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
typedef CartItemCallback = void Function(CartItem cartItem);

class _HomePageState extends State<HomePage> {
  late final String appBarTxt = 'Welcome ${user?.email}';
  final List<CartItem> cartItems = [];
  void _addToCart(CartItem cartItem) {
    setState(() {
      cartItems.add(cartItem);
    });
  }

  final User? user = Auth().currentUser;
 //instance of the auth class which checks for the current user
  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _title(){
    return Text('Welcome', style: GoogleFonts.oswald(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white), );
  }

  Widget _userUid(){
    //I'm assuming if the mail is null it displays user email
    return Text(user?.email ?? 'User email', style: GoogleFonts.mulish(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Colors.white),);
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
 /* final List<Widget> _screens = [
    const DashboardScreen(),
    BarcodeScreen(),
    SettingPage()
  ];*/


  @override
  Widget build(BuildContext context) =>
    // TODO: implement build
  Scaffold(
        appBar: AppBar(
          backgroundColor: lightAppTheme.primaryColor,
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 10,
          toolbarHeight: 70,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            //the appbar calls two functions which displays the welcome text and their email below it
            children: [
              _title(),
              _userUid()
            ],
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SearchScreen()));
                },
                icon: Icon(Icons.search_outlined, color: Colors.white,)
            ),
            IconButton(
                onPressed: (){
                 /* Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CartScreen()));*/
                },
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,))
          ],
        ),
        drawer: MyDrawer(),

        //call the screens function with the selected index at 0 so the first page is the dashboard screen
        body: DashboardScreen(),
        // _screens[_selectedindex],

        //a google bottom navigation bar
        /*bottomNavigationBar:  Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              hoverColor: Colors.grey,
              activeColor: lightAppTheme.primaryColor,
              tabBackgroundColor: Colors.black,
              gap: 10,
              padding: EdgeInsets.all(15),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.barcode_reader,
                  text: 'Scan barcode',
                ),
                GButton(
                  icon: Icons.settings_outlined,
                  text: 'Settings',
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
        )*/
    );




}

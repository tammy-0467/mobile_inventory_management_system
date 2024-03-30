import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/inventory_screens/dashboard_product_details.dart';
import 'package:untitled/inventory_screens/product_details.dart';
import 'package:untitled/inventory_screens/cart_screen.dart';

import '../authentication_screens/auth.dart';
import '../inventory_screens/manual_data_entry.dart';
import '../settings_screen.dart';
import '../tab_bar_screens/barcode_reg_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String? scanResult;
  Future<void> signOut() async{
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      backgroundColor: Colors.lightBlue.shade500,
      child: Column(
          children: [
            DrawerHeader(
                child: Image.asset("assets/images/babcock_logo.png",
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                )),
            /*ListTile(
              leading: Icon(Icons.add, color: Colors.white),
              title: Text("A D D  I T E M S", style: GoogleFonts.mulish(
                  fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ManualEntryScreen()));
              },
            ),*/
            ListTile(
                leading: Icon(Icons.app_registration_outlined, color: Colors.white),
                title: Text("R E G I S T E R  I T E M S", style: GoogleFonts.mulish(
                    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> ManualEntryScreen()));
                }
            ),
            ListTile(
                leading: Icon(Icons.barcode_reader, color: Colors.white),
                title: Text("S C A N  B A R C O D E", style: GoogleFonts.mulish(
                    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                ),
                onTap: scanBarcode
            ),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("L O G O U T", style: GoogleFonts.mulish(
                    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                ),
                onTap: (){
                  signOut();
                }
            ),
            /*ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("S E T T I N G S", style: GoogleFonts.mulish(
                    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white)
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> SettingPage()));
                }
            ),*/
          ]
      ),
    );
  }

    Future  scanBarcode() async{
      String scanResult;
      try {
        scanResult = await FlutterBarcodeScanner.scanBarcode(
            "#ADD8E6", "Cancel", true, ScanMode.BARCODE);
      } on PlatformException {
        scanResult = 'Failed to get Platform version';
        Navigator.pop(context);
      }
      if (!mounted) return;



      // Check if the scanned barcode already exists in your database
      bool barcodeExists = await checkIfBarcodeExists(scanResult);

      if (barcodeExists) {
        // Navigate to the product details screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardDetails(documentID: scanResult)),
        );
      } else {
        // Navigate to the barcode screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BarcodeScreen(result: scanResult)),
        );
      }

      setState(() =>
      this.scanResult = scanResult);

  }
  Future<bool> checkIfBarcodeExists(String barcode) async {
    // Query Firestore database to check if a document with the scanned barcode exists
    // Replace 'inventory' with actual collection name
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('inventory').doc(barcode).get();

    // Return true if the document exists, otherwise return false
    return document.exists;
  }
}


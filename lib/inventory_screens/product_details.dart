import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/custom_styles/app_theme.dart';

class ProductInfoScreen extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final int noOfUnits;
  final String documentID;
  final int priceOfUnit;

  //get the data passed from the previous screen
  const ProductInfoScreen({Key? key, required this.itemName, required this.itemDesc, required this.noOfUnits, required this.priceOfUnit,required this.documentID }) : super(key: key);

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {


  //document IDs
  List<String> docIDs = [];
  
  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('inventory').get().then((
        snapshot) => snapshot.docs.forEach((document) {
          print(document.reference);
          docIDs.add(document.reference.id);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details", style: GoogleFonts.mulish(
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
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(widget.itemName),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Category", style: lightAppTheme.textTheme.labelLarge,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(widget.noOfUnits.toString()),
                    ),
                  ],
                ),
                // SizedBox(width: 40,),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 160,
                    width: 160,
                    color: lightAppTheme.primaryColor,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text("Product Description", style: lightAppTheme.textTheme.titleLarge,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(widget.itemDesc,
              textAlign: TextAlign.justify,
              style: lightAppTheme.textTheme.labelLarge,
              maxLines: 10,
              softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Product ID:  ", style: lightAppTheme.textTheme.labelLarge,),
                  Text(widget.documentID, style: lightAppTheme.textTheme.labelLarge,),
                ],
              ),
            ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Price:  ", style: lightAppTheme.textTheme.labelLarge,),
              Text(widget.priceOfUnit.toString(), style: lightAppTheme.textTheme.labelLarge,),
            ],
          ),
        )
          ],
        ),
      ),
    );
  }
}

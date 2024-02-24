import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/databse_files/get_inventory_data.dart';

import '../custom_styles/app_theme.dart';

class DashboardDetails extends StatelessWidget {

  //get the referenced document ID from the previous page
  final String documentID;
  const DashboardDetails({ Key? key,
    required this.documentID
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    return FutureBuilder<DocumentSnapshot>(
      //wait for the builder to get information(document ID) from the inventory collection
      future: inventory.doc(documentID).get(),
      builder: (context, snapshot){
        //if connection has been established with firebase
        //make the data within a snapshot a hashmap
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //get the corresponding documents data and assign them to variables
          String name = data['item name'];
          String description = data['item description'];
          int noOfUnits = data['no of units'];
          int priceOfUnits = data['price of a unit'];
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
                            child: Text(name),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Category", style: lightAppTheme.textTheme.labelLarge,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(noOfUnits.toString()),
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
                    child: Text(description,
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
                        Text("Document ID", style: lightAppTheme.textTheme.labelLarge,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Price:  ", style: lightAppTheme.textTheme.labelLarge,),
                        Text(priceOfUnits.toString(), style: lightAppTheme.textTheme.labelLarge,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          //if connection is not established, loading scren
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/databse_files/get_inventory_data.dart';
import 'package:untitled/inventory_screens/dashboard_product_details.dart';

import '../custom_styles/app_theme.dart';
import '../custom_styles/my_box.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  //document IDs
  late Future<List<String>> docIDsFuture;

  @override
  void initState() {
    super.initState();
    //assign the values returned from the getDocId function to the docIDsFuture list to prevent a repetition of elements
    docIDsFuture = getDocId();
  }

  Future<List<String>> getDocId() async {
    List<String> docIDs = [];

    //get the document IDs from the inventory collection within firebase and store them in the docIDs List
    //assign the value of the current document ID to the snapshot variable
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('inventory').get();
    querySnapshot.docs.forEach((document) {
      docIDs.add(document.reference.id);
    });
    return docIDs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //a simple list view
        Expanded(
            child: FutureBuilder(
              //make the screen wait for the docIDsFuture to get it's values
              future: docIDsFuture,
              builder: (context, snapshot){
                //if the app is still getting information from the database display a loading widget
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                  //if there is an error, display it
                      return Center(child: Text('Error: ${snapshot.error}'));
                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //if there is no data within the collection display text
                        return Center(child: Text('No data available'));
                    } else {
                  //otherwise build the layout as planned
                        return ListView.builder(
                          //make the list items as long as the number of elements in the inventory collection
                          // (it counts the number of document IDs)
                          //use ! as a fail safe in case the collection is null
                             itemCount: snapshot.data!.length,
                             itemBuilder: (context, index){
                               // when each individual container is tapped, navigate to a new screen
                               return GestureDetector(
                                   onTap: () {
                                 Navigator.of(context).push(MaterialPageRoute(
                                   builder: (_) => DashboardDetails(
                                     //the documentID of the container is passed to the next screen
                                      documentID: snapshot.data![index],
                                   ),
                                 ));
                               },
                                 child: Padding(
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
                                        //display the product name assigned to the docID
                                        GetProductName(documentID: snapshot.data![index]),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //display the no of units & price of a unit assigned to the docID
                                        GetNoOfUnits(documentID: snapshot.data![index]),
                                        GetPriceOfUnits(documentID: snapshot.data![index])
                                      ],
                                    ),
                                  ],
                                       ),
                                     ),
                                     color: lightAppTheme.primaryColor,
                                     height: 80,
                                   ),
                                 ),
                               );
                                                /*ListTile(
                          title: GetProductName(documentID: docIDs[index],),
                          subtitle: Row(
                            children: [
                              GetNoOfUnits(documentID: docIDs[index]),
                              GetPriceOfUnits(documentID: )
                            ],
                          ),
                                                );*/

                             }
                             );

                }
              },

            )
        )
      ],
    );
  }
}

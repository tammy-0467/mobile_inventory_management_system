import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/databse_files/get_inventory_data.dart';
import 'package:untitled/inventory_screens/dashboard_product_details.dart';

import '../custom_styles/app_theme.dart';
import '../custom_styles/drawer_file.dart';
import '../custom_styles/my_box.dart';
import '../inventory_screens/cart_screen.dart';
import '../model/cart_model.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<CartItem> cartItems = [];
  final nairaFormat = NumberFormat.currency(locale: 'en_NG', name: 'NGN');

  void _addToCart(CartItem cartItem) {
    setState(() {
      cartItems.add(cartItem);
    });
  }

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
    return  Scaffold(
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
                /*   _title(),
                 _userUid()*/
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CartScreen(cartItems: cartItems,)));
                         },
                        icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,))
                     ],
                    ),
                   drawer: MyDrawer(),

                   //call the screens function with the selected index at 0 so the first page is the dashboard screen
            body: Column(
                     children: [
                     //a simple list view
                      Expanded(
                           child: StreamBuilder<QuerySnapshot>(
                              //make the screen wait for the docIDsFuture to get it's values
                              stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
                              builder: (context, snapshot){
                              //if the app is still getting information from the database display a loading widget
                              if (snapshot.hasData) {
                              List<DocumentSnapshot> documents = snapshot.data!.docs;
                              //otherwise build the layout as planned
                              return ListView.builder(
                              //make the list items as long as the number of elements in the inventory collection
                              // (it counts the number of document IDs)
                             //use ! as a fail safe in case the collection is null
                             itemCount: documents.length,
                             itemBuilder: (context, index){
                             String documentId = documents[index].id;
                            // when each individual container is tapped, navigate to a new screen
                                   return GestureDetector(
                                   onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                       builder: (_) => DashboardDetails(
                                       //the documentID of the container is passed to the next screen
                                        documentID: documentId,
                                         onCartItemAdded: _addToCart,
                                   ),
                                 ));
                                  },
                                        child: Padding(
                                         //adds space between all boxes
                                           padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                       borderRadius: BorderRadius.circular(20),
                                                       border: Border.all(color: lightAppTheme.primaryColor)
                                                ),
                                                height: 80,
                                                child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                         children: [
                                                            Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             children: [
                                                               GetProductName(documentID: documentId),
                                        /*IconButton(
                                                        onPressed: (){
                                                          addItemToCart(documentId);
                                                        },
                                                        icon: Icon(Icons.add_outlined, size: 10,))*/
                                                   ],
                                                   ),
                                                       Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                           children: [
                                                           //display the no of units & price of a unit assigned to the docID
                                                               GetPriceOfUnits(documentID: documentId)
                                                             ],
                                                         ),
                                            ],
                                ),



                              ),
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

                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },

            )
        )
      ],
    ),
    );



  }
}

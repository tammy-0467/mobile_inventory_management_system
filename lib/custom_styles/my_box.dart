import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:untitled/inventory_screens/manual_data_entry.dart';
import 'package:untitled/settings_screen.dart';
import 'package:untitled/tab_bar_screens/barcode_reg_screen.dart';
import '../authentication_screens/auth.dart';
import '../databse_files/get_inventory_data.dart';
import '../inventory_screens/dashboard_product_details.dart';
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


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightAppTheme.primaryColor,
        title: Text('Search', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search items...',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('inventory')
                  .where('item name', isGreaterThanOrEqualTo: _searchQuery)
                  .where('item name', isLessThan: _searchQuery + 'z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var document = snapshot.data!.docs[index];
                      String documentId = document.id;
                      return GestureDetector(
                        onTap: (){
                             Navigator.of(context).push(MaterialPageRoute(
                             builder: (_) => DashboardDetails(
                             //the documentID of the container is passed to the next screen
                             documentID: documentId,
                             ),
                             ));
                             },
                        child: Padding(
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
                                      //display the product name assigned to the docID
                                      GetProductName(documentID: documentId),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //display the no of units & price of a unit assigned to the docID
                                      GetNoOfUnits(documentID: documentId),
                                      GetPriceOfUnits(documentID: documentId)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CustomInputQty extends StatefulWidget {
  final num initVal;
  final Function(num) onQtyChanged;
  const CustomInputQty({super.key, required this.initVal, required this.onQtyChanged});

  @override
  State<CustomInputQty> createState() => _CustomInputQtyState();
}

class _CustomInputQtyState extends State<CustomInputQty> {
  @override
  Widget build(BuildContext context) {
    return InputQty(
      decoration: QtyDecorationProps(
        isBordered: false,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        minusBtn: Icon(Icons.remove_circle_outline, color: lightAppTheme.primaryColor, size: 35,),
        plusBtn: Icon(Icons.add_circle_outline_outlined, color: lightAppTheme.primaryColor, size: 35,)
      ),
      initVal: widget.initVal,
      steps: 1,
      minVal: 0,
      maxVal: 100,
      onQtyChanged: (val){
        setState(() {
          widget.onQtyChanged(val);
        });
      },
    );
  }
}




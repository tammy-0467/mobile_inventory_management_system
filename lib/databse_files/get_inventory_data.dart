import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:intl/intl.dart';

class GetProductName extends StatelessWidget {

  final String documentID;
  const GetProductName({required this.documentID});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    return FutureBuilder<DocumentSnapshot>(
        future: inventory.doc(documentID).get(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Text("Product Name: ${data['item name']} " , style: TextStyle(color: Colors.black) );
          }
          return Text('loading...');
        },
    );
  }
}

class GetProductDesc extends StatelessWidget {

  final String documentID;
  const GetProductDesc({required this.documentID});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    return FutureBuilder<DocumentSnapshot>(
      future: inventory.doc(documentID).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text(" ${data['item description']}" , style: TextStyle(color: Colors.black),);
        }
        return Text('loading...');
      },
    );
  }
}

class GetNoOfUnits extends StatelessWidget {

  final String documentID;
  const GetNoOfUnits({required this.documentID});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    return FutureBuilder<DocumentSnapshot>(
      future: inventory.doc(documentID).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Units available: ${data['no of units']}" , style: TextStyle(color: Colors.black) );
        }
        return Text('loading...');
      },
    );
  }
}

class GetPriceOfUnits extends StatelessWidget {

  final String documentID;
  const GetPriceOfUnits({required this.documentID});


  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    final nairaFormat = NumberFormat.currency(locale: 'en_NG', name: 'NGN ', symbol: '₦ ');

    return FutureBuilder<DocumentSnapshot>(
      future: inventory.doc(documentID).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          int unitPrice = data['price of a unit'];
          return Text("Price: ${nairaFormat.format(unitPrice)}"  , style: TextStyle(color: Colors.black));
        }
        return Text('loading...');
      },
    );
  }
}
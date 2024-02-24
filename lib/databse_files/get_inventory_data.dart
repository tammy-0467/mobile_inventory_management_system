import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            return Text("Product Name: ${data['item name']}" );
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
          return Text(" ${data['item description']}" );
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
          return Text("${data['no of units']}" );
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
    return FutureBuilder<DocumentSnapshot>(
      future: inventory.doc(documentID).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("${data['price of a unit']}" );
        }
        return Text('loading...');
      },
    );
  }
}
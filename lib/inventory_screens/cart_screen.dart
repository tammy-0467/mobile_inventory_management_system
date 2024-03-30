import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../custom_styles/app_theme.dart';
import '../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _updateInventory() async {
    final inventoryCollection = FirebaseFirestore.instance.collection('inventory');

    for (final item in widget.cartItems) {
      final documentId = await _getDocumentIdByName(item.itemName);
      if (documentId != null) {
        final documentRef = inventoryCollection.doc(documentId);
        final documentSnapshot = await documentRef.get();
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final currentUnits = data['no of units'] as int;
          final newUnits = currentUnits - item.quantity;
          await documentRef.update({'no of units': newUnits});
        }
      }
    }
    setState(() {
      widget.cartItems.clear();
    });
    Fluttertoast.showToast(
      msg: 'Paid successfully',
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: lightAppTheme.primaryColor,
      textColor: Colors.white,
    );
  }

  Future<String?> _getDocumentIdByName(String itemName) async {
    final inventoryCollection = FirebaseFirestore.instance.collection('inventory');
    final querySnapshot = await inventoryCollection.get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['item name'] == itemName) {
        return doc.id;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final nairaFormat = NumberFormat.currency(locale: 'en_NG', name: 'NGN ', symbol: '₦ ');
    int totalPrice = 0;
    for (final item in widget.cartItems) {
      totalPrice += item.totalPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: GoogleFonts.mulish(
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return
                  ListTile(
                    title: Text(item.itemName),
                    subtitle: Row(
                      children: [
                        Text('Price: ${nairaFormat.format(item.itemPrice)}'),
                        SizedBox(width: 16),
                        Text('Quantity: ${item.quantity}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total: ${nairaFormat.format(item.totalPrice)}'),
                        IconButton(
                          onPressed: () {
                            // Remove the item from the cartItems list
                            setState(() {
                              widget.cartItems.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                      ],
                    ),
                  );
                /*Container(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(item.itemName),
                          Row(
                            children: [
                              Text('Price: ${item.itemPrice}'),
                              SizedBox(width: 16),
                              Text('Quantity: ${item.quantity}'),
                            ],
                          ),
                          Text('Total: ${item.totalPrice}'),
                        ],
                      ),
                      IconButton(onPressed: (){},
                          icon: Icon(Icons.close_outlined))
                    ],
                  ),
                );*/


              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  nairaFormat.format(totalPrice),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _updateInventory();
                },
              child: Text("Pay"),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 0))
              ),
            ),
          )
        ],
      ),
    );
  }
}
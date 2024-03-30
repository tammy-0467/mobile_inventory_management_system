import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:untitled/custom_styles/edit_delete_dialogs.dart';
import 'package:untitled/custom_styles/my_box.dart';
import 'package:untitled/databse_files/get_inventory_data.dart';
import 'package:untitled/tab_bar_screens/dashboard.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../custom_styles/app_theme.dart';
import '../model/cart_model.dart';

class DashboardDetails extends StatefulWidget {
  //get the referenced document ID from the previous page
  final String documentID;
  final CartItemCallback? onCartItemAdded;
  const DashboardDetails({ Key? key,
    required this.documentID, this.onCartItemAdded
  }) : super(key: key);


  @override
  State<DashboardDetails> createState() => _DashboardDetailsState();
}

typedef CartItemCallback = void Function(CartItem cartItem);

class _DashboardDetailsState extends State<DashboardDetails> {
  //generate a formKey used tp control the states of all textFormFields
  final formKey = GlobalKey<FormState>();
  num quantityAddedToCart = 0;
  late final CartItemCallback onCartItemAdded;

  File? _imageFile;
  String? _imageUrl;
  UploadTask? uploadTask;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadImg() async {
    final fileName = _imageFile!.path.split('/').last;
    final path = 'product_images/${fileName}';
    final img = File(_imageFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(img);

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('inventory')
        .doc(widget.documentID)
        .update({'image Url': urlDownload});
  }
  



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onCartItemAdded = widget.onCartItemAdded ?? (_) {};
    /*_fetchImageUrl();*/
  }
  Future<void> _handleAddToCart(int inventoryUnits, String productName) async {
    if (quantityAddedToCart <= inventoryUnits && quantityAddedToCart != 0) {
      CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
      DocumentSnapshot snapshot = await inventory.doc(widget.documentID).get();
      if(snapshot.exists ){
        int priceOfUnits = snapshot.get('price of a unit');
        final int totalPrice = quantityAddedToCart.toInt() * priceOfUnits;
        final cartItem = CartItem(
          itemName: productName,
          itemPrice: priceOfUnits,
          quantity: quantityAddedToCart.toInt(),
          totalPrice: totalPrice,
        );
        onCartItemAdded(cartItem);
       /* final imageUrl = await _uploadImage();
        if (imageUrl != null) {
          await FirebaseFirestore.instance
              .collection('inventory')
              .doc(widget.documentID)
              .update({'image Url': imageUrl});

          setState(() {
            _imageUrl = imageUrl;
          });
        }*/
      }

      Fluttertoast.showToast(
        msg: '${productName} successfully added to cart',
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: lightAppTheme.primaryColor,
        textColor: Colors.white,
      );
      // Add additional logic here if needed, such as updating the cart or inventory
    } else if (quantityAddedToCart == 0){
      Fluttertoast.showToast(
        msg: 'Increase number of items to be added to cart',
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: lightAppTheme.primaryColor,
        textColor: Colors.white,
      );
    }

    else {
      Fluttertoast.showToast(
        msg: 'You don\'t have enough units in the inventory',
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: lightAppTheme.primaryColor,
        textColor: Colors.white,
      );
    }
  }
  void updateQuantityAddedToCart(num value) {
    setState(() {
      quantityAddedToCart = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference inventory = FirebaseFirestore.instance.collection("inventory");
    final nairaFormat = NumberFormat.currency(locale: 'en_NG', name: 'NGN ', symbol: '₦ ');
    return StreamBuilder<DocumentSnapshot>(
      //wait for the builder to get information(document ID) from the inventory collection
      stream: inventory.doc(widget.documentID).snapshots(),
      builder: (context, snapshot){
        //if connection has been established with firebase
        //make the data within a snapshot a hashmap
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //get the corresponding documents data and assign them to variables
          String name = data['item name'];
          String description = data['item description'];
          int noOfUnits = data['no of units'];
          int priceOfUnits = data['price of a unit'];
          final imageUrl = data['image Url'] as String?;
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
              actions: [
                IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return CustomBottomSheet(documentID: widget.documentID,);
                        });
                  },
                    icon: Icon(Icons.edit_outlined), style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
                ),
                IconButton(onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return CustomDialogBox(documentID: widget.documentID,);
                      });
                }, icon: Icon(Icons.delete_outline), style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white))
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(name, style: lightAppTheme.textTheme.headlineSmall,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Select Image Source'),
                              content: Text('Choose where to pick the image from.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Gallery'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Camera'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _imageUrl != null
                         ? Image.network(
                          imageUrl!,
                          width: 200,
                          height: 200,
                        ) :
                        _imageFile == null
                              ? Icon(Icons.camera_alt, size: 40)
                              : Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text("Units Available: "),
                              Text(noOfUnits.toString()),
                            ],
                          ),
                        ),
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
                          Text(nairaFormat.format(priceOfUnits) , style: lightAppTheme.textTheme.labelLarge,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("QUANTITY", style: lightAppTheme.textTheme.titleLarge,),
                    ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: CustomInputQty(
                         initVal: quantityAddedToCart,
                       onQtyChanged: updateQuantityAddedToCart,
                     ),
                   ),
                    ElevatedButton(
                        onPressed: () async {
                          await uploadImg();
                         _handleAddToCart(noOfUnits, name);
                        },
                        child: Text("Add to cart"),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 0))
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } /*else {
          //if connection is not established, loading scren
          return Center(child: CircularProgressIndicator());
        }*/
      },

    );
  }
}




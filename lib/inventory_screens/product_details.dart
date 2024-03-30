import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:untitled/custom_styles/app_theme.dart';

import '../custom_styles/edit_delete_dialogs.dart';
import '../custom_styles/my_box.dart';
import '../model/cart_model.dart';

class ProductInfoScreen extends StatefulWidget {
  final String itemName;
  final String itemDesc;
  final int noOfUnits;
  final String documentID;
  final int priceOfUnit;
  final String? imageURl;
  final CartItemCallback? onCartItemAdded;

  //get the data passed from the previous screen
  const ProductInfoScreen({Key? key, required this.itemName, required this.itemDesc, required this.noOfUnits, required this.priceOfUnit,required this.documentID, this.imageURl, this.onCartItemAdded}) : super(key: key);

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

typedef CartItemCallback = void Function(CartItem cartItem);

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  File? _imageFile;
  String? _imageUrl;
  UploadTask? uploadTask;
  late final CartItemCallback onCartItemAdded;

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
    onCartItemAdded = widget.onCartItemAdded ?? (_) {};
  }

  deleteItem() async {
    try {
      // Delete item from Firestore using its document ID
      await FirebaseFirestore.instance.collection('inventory').doc(widget.documentID).delete();
      // Close the dialog box
      Navigator.pop(context);
    } catch (e) {
      // Handle errors, if any
      print("Error deleting item: $e");
    }
  }

  num quantityAddedToCart = 0;

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
    final nairaFormat = NumberFormat.currency(locale: 'en_NG', name: 'NGN ', symbol: '₦ ');
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details", style: GoogleFonts.mulish(
            fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white),),
        backgroundColor: lightAppTheme.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
                  child: Text(widget.itemName, style: lightAppTheme.textTheme.headlineSmall,),
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
                      widget.imageURl!,
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
                        Text(widget.noOfUnits.toString()),
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
                    Text(nairaFormat.format(widget.priceOfUnit) , style: lightAppTheme.textTheme.labelLarge,),
                  ],
                ),
              ),
             /* Padding(
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
                  _handleAddToCart(widget.noOfUnits, widget.itemName);
                },
                child: Text("Add to cart"),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 0))
                ),
              )*/
            ],
          ),
        ),
      ),
      /*body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text("Units Available: "),
                      Text(widget.noOfUnits.toString()),
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
                  Text(nairaFormat.format(widget.priceOfUnit), style: lightAppTheme.textTheme.labelLarge,),
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
              onPressed: () {
                _handleAddToCart(widget.noOfUnits, widget.itemName);
              },
              child: Text("Add to cart"),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 0))
              ),
            )
          ],
        ),
      ),*/
    );
  }
}

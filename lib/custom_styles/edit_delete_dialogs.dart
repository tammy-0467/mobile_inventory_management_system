import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../tab_bar_screens/dashboard.dart';
import 'app_theme.dart';

class CustomBottomSheet extends StatefulWidget {

  final String documentID;
  CustomBottomSheet({ Key? key,
    required this.documentID
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _noOfUnitsController = TextEditingController();
  final _detailsInputController = TextEditingController();
  final _unitPriceController = TextEditingController();
  bool _isLoading = true;


  Widget _entryField(String title,
      TextEditingController controller,
      int max,
      bool isNumField
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
      //if it is a numbers only field, change the keyboard type accordingly
      keyboardType: isNumField? TextInputType.number : TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose([
        Validators.required("This field is required"),
        // if it is a num only field generate this specific error
        if (isNumField)
          Validators.patternString(r'^[0-9]*$', "Only numbers within this field"),
      ]),
      maxLines: max,
    );
  }

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: () async {
        //if validation is complete, assign the text within the controllers(form fields)
        // to their corresponding variables
        if (formKey.currentState!.validate()) {
          String itemName = _inputController.text;
          int noOfUnits = int.parse(_noOfUnitsController.text);
          int priceOfUnit = int.parse(_unitPriceController.text);
          String itemDesc = _detailsInputController.text;

          //reset the forms when navigation is complete
          formKey.currentState?.reset();
          // Update inventory items in Firesbase
          try {
            DocumentReference docRef = await updateInventoryItems(itemName, noOfUnits, priceOfUnit, itemDesc);

            String documentID = docRef.id;
            setState(() {
              _isLoading = false;
            });
            // Form is valid, navigate to the next screen
            Navigator.pop(context);
          } catch (e){
            setState(() {
              _isLoading = false;
            });
          }
        }
      },

      child: Text("Edit"),
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(200, 0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              )
          )
      ),
    );
  }

  Future<DocumentReference> updateInventoryItems(String itemName, int noOfUnits, int priceOfUnit, String itemDesc) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('inventory').doc(widget.documentID);

    await docRef.update({
      'item name': itemName,
      'no of units': noOfUnits,
      'price of a unit': priceOfUnit,
      'item description': itemDesc,
    }
    );
    return docRef;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Edit Product Details", style: lightAppTheme.textTheme.headlineSmall,),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Product Name", style: lightAppTheme.textTheme.titleLarge,),
                  )),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:_entryField('Input item name', _inputController, 1, false),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Number of units added", style: lightAppTheme.textTheme.titleLarge,),
                  )),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: _entryField('Input number of units added', _noOfUnitsController, 1, true),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Price of a Unit", style: lightAppTheme.textTheme.titleLarge,),
                  )
              ),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: _entryField('Input unit price', _unitPriceController, 1,true),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Product Description", style: lightAppTheme.textTheme.titleLarge,),
                  )),
              SizedBox(height: 6,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: _entryField('Input information about the product', _detailsInputController, 5, false),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _submitButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialogBox extends StatefulWidget {
  final String documentID;
  const CustomDialogBox({ Key? key,
    required this.documentID
  }) : super(key: key);

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete item"),
      content: Text("Are you sure you want to delete this item from your inventory?"),
      actions: <Widget>[
        TextButton(
            onPressed: (){
          Navigator.pop(context);
        }, child: Text("No")
        ),
        TextButton(
            onPressed: () async {
                try {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Delete item from Firestore using its document ID
                  await FirebaseFirestore.instance.collection('inventory').doc(widget.documentID).delete();
                  // Close the dialog box
                  Navigator.pop(context);

                } catch (e) {
                  // Handle errors, if any
                  print("Error deleting item: $e");
                }
                 // Close dialog
                // Close details screen


            }, child: Text("Yes")
        ),
      ],
    );
  }
}



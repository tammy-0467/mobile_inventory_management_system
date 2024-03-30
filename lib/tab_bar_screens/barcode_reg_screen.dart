import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/inventory_screens/manual_data_entry.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../inventory_screens/product_details.dart';

class BarcodeScreen extends StatefulWidget {
  final String result;
  const BarcodeScreen({Key? key, required this.result}): super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  //generate a formKey used tp control the states of all textFormFields
  final formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _noOfUnitsController = TextEditingController();
  final _detailsputController = TextEditingController();
  final _unitPriceController = TextEditingController();

  Widget _entryField(String title,
      TextEditingController? controller,
      int max,
      bool isNumField,
      bool isEdit
      ) {
    return TextFormField(
      controller: controller,
      enabled: isEdit,
      decoration: InputDecoration(
        labelText: title,
      ),
      //if it is a numbers only field, change the keyboard type accordingly
      keyboardType: isNumField? TextInputType.number : TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose([
        if (isEdit == true)
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
          String itemDesc = _detailsputController.text;

          //reset the forms when navigation is complete
          formKey.currentState?.reset();
          try {
            await FirebaseFirestore.instance.collection("inventory").doc(widget.result).set(
              {
                'item name': itemName,
                'no of units': noOfUnits,
                'price of a unit': priceOfUnit,
                'item description': itemDesc,
              });
          } catch (e) {
            print("Error adding items: $e");
          }

          // String documentID = docRef.id;
          // Form is valid, navigate to the next screen
          Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
          //pass the variable information from this screen to the product details screen
          ProductInfoScreen(itemName: itemName, itemDesc: itemDesc, noOfUnits: noOfUnits, priceOfUnit: priceOfUnit, documentID: widget.result,)
          ));
        }
      },


      child: Text("Submit"),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Registeration"),
        backgroundColor: lightAppTheme.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter Product Details", style: lightAppTheme.textTheme.headlineMedium,),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("Product ID", style: lightAppTheme.textTheme.titleLarge,),
                      )),
                  SizedBox(height: 6,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child:_entryField(widget.result, null, 1, false, false),
                  ),
                  SizedBox(height: 6,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("Product Name", style: lightAppTheme.textTheme.titleLarge,),
                      )),
                  SizedBox(height: 6,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child:_entryField("Input product Name", _inputController, 1, false, true),
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
                    child: _entryField('Input number of units added', _noOfUnitsController, 1, true, true),
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
                    child: _entryField('Input unit price', _unitPriceController, 1,true, true),
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
                    child: _entryField('Input information about the product', _detailsputController, 5, false, true),
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
        ),
      ),
    );
  }


}


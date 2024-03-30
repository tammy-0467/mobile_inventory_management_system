import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/inventory_screens/product_details.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {

  //generate a formKey used tp control the states of all textFormFields
  final formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _noOfUnitsController = TextEditingController();
  final _detailsputController = TextEditingController();
  final _unitPriceController = TextEditingController();

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
          String itemDesc = _detailsputController.text;


          // Add inventory items to Firestore
          DocumentReference docRef = await addInventoryItems(itemName, noOfUnits, priceOfUnit, itemDesc);

          String documentID = docRef.id;
          // Form is valid, navigate to the next screen
          Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
          //pass the variable information from this screen to the product details screen
          ProductInfoScreen(itemName: itemName, itemDesc: itemDesc, noOfUnits: noOfUnits, priceOfUnit: priceOfUnit, documentID: documentID,)
          ));
          //reset the forms when navigation is complete
          formKey.currentState?.reset();
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

  //adding inventory data to database
  Future<DocumentReference> addInventoryItems(String itemName, int noOfUnits, int priceOfUnit, String itemDesc) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('inventory').add({
      'item name': itemName,
      'no of units': noOfUnits,
      'price of a unit': priceOfUnit,
      'item description': itemDesc,
    });
    return docRef;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      child: _entryField('Input information about the product', _detailsputController, 5, false),
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

import 'package:flutter/material.dart';
import 'package:untitled/custom_styles/app_theme.dart';

class BarcodeScreen extends StatelessWidget {
  const BarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Scan QR code", style: appTheme.textTheme.headlineMedium,),
            ),
            Container(
              height: 150,
              width: 150,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Can't scan barcode? ", style: appTheme.textTheme.bodyLarge,),
                 /* Padding(padding: EdgeInsets.symmetric(horizontal: 5)),*/
                  TextButton(
                      onPressed: (){},
                      child: Text("Click here", style: appTheme.textTheme.bodyLarge,))
                ],
              ),
            )
        
          ],
        ),
      ),
    );
  }
}

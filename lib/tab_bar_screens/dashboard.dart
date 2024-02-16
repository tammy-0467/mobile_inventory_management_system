import 'package:flutter/material.dart';

import '../custom_styles/my_box.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // keeps the gridview responsive (makes sure the boxes are in a 2x2 format)
        AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            // 4 boxes on the top (dashboard)
            child: GridView.builder(
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index){
                  return MyBox();
                }
            ),
          ),
        ),
        //a simple list view
        Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index){
                  return MyTile();
                }))
      ],
    );
  }
}

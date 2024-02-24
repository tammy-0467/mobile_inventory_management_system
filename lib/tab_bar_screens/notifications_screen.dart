 import 'package:flutter/material.dart';
import 'package:untitled/custom_styles/app_theme.dart';
import 'package:untitled/custom_styles/my_box.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Align(
              child: Text("Notifications",
                style: lightAppTheme.textTheme.headlineMedium,)
           ),
          Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return NotificationTile();
                  }))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

//custom navigation animations
class CustomPageRoute extends PageRouteBuilder{
  final Widget child;
  final AxisDirection direction;
  CustomPageRoute({
    required this.child,
    required this.direction
}): super (
    transitionDuration: Duration(milliseconds: 700),
    reverseTransitionDuration: Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  )

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getStartOffset(),
        end: Offset.zero
      ).animate(animation),
      child: child,
    );
  }

  Offset getStartOffset(){
    switch(direction) {
      case AxisDirection.up:
        return Offset(0, 1);
      case AxisDirection.down:
        return Offset(0, -1);
      case AxisDirection.right:
        return Offset(-1, 0);
      case AxisDirection.left:
        return Offset(1, 0);
    }
  }
}
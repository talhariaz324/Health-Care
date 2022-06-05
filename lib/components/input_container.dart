import 'package:flutter/material.dart';



class InputContainer extends StatelessWidget {
  const InputContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.007),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.007),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.1),
        color: Theme.of(context).primaryColor.withAlpha(50)
      ),

      child: child
    );
  }
}
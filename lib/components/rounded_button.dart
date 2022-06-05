import 'package:flutter/material.dart';



class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.trySubmit,
  }) : super(key: key);

  final String title;
  final Function trySubmit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        trySubmit();
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.secondary,
        ),

        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          title,
          style:  TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}
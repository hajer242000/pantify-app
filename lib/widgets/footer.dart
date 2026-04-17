

import 'package:flutter/material.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/custom_button.dart' show CustomButton;

class Footer extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const Footer({super.key, required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: width(context),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 202, 201, 201),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: CustomButton(
            isCustomized: false,
            isDetailButton: false,
            onPressed: onPressed,
            title: title,
          ),
        ),
      ),
    );
  }
}

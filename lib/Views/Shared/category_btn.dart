import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:flutter/material.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn(
      {super.key, this.onPress, required this.buttonClr, required this.label});
  final void Function()? onPress;
  final Color buttonClr;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPress,
      child: Container(
        height: MediaQuery.of(context).size.height*0.0431,
        width: MediaQuery.of(context).size.width*0.24,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: buttonClr,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: appstyle(15, buttonClr, FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

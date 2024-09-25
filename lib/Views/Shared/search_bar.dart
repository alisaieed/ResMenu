import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key,
      required this.textController,
      required this.hintText,
      required this.onEditingCompleted,
      required this.keyboard,
      this.suffixIcon,
      this.prefixIcon});

  final TextEditingController textController;
  final String hintText;
  final void Function()? onEditingCompleted;
  final TextInputType keyboard;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
      child: TextField(
        keyboardType: keyboard,
        onEditingComplete: onEditingCompleted,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          suffixIconColor: Colors.black,
          hintStyle: appstyle(16, Colors.grey, FontWeight.w500),
          contentPadding: EdgeInsets.zero
        ),
      ),
        );

  }
}

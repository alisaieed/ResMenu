import 'package:flutter/material.dart';

class BotomNavWidget extends StatelessWidget {
  const BotomNavWidget({
    super.key, this.onTap, this.icon,
  });
final void Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  SizedBox(
        height: MediaQuery.of(context).size.height*0.0444,
        width: MediaQuery.of(context).size.width*0.096,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
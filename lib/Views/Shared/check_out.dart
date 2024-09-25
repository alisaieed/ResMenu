import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'appstyle.dart';

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({
    super.key, this.onTap, required this.label,
  });

  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          height: MediaQuery.of(context).size.height*0.06,
          width: MediaQuery.of(context).size.width*0.5,
          child: Center(
            child: Text(
              label,
              style: appstyle(16, Colors.white, FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}

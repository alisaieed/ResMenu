import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    var mainScreenNotifier = Provider.of<MainScreenNotifier>(context);

    return SafeArea(
      child: Scaffold(

          backgroundColor: const Color(0xFFE2E2E2),

          body: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding:  EdgeInsets.fromLTRB(8.w,100.h,8.w,20.h),
                  child:  Text(
                    AppLocalizations.of(context)!.signup,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.userName,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.userEmail,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                ),
              ),
              Container(
                  height: 70.h,
                  padding:  EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 0.h),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.black
                      )
                    ),
                    child:  Text(AppLocalizations.of(context)!.signup,),
                    onPressed: () async {
                      print(nameController.text);
                      print(passwordController.text);
                      print(emailController.text);

                      try {
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        mainScreenNotifier.pageIndex = 4;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }

                    },
                  )
              ),
            ],
          )),
    );
  }
}
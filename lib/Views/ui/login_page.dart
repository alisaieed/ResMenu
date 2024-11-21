import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var mainScreenNotifier = Provider.of<MainScreenNotifier>(context);

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding:  EdgeInsets.fromLTRB(8.w,MediaQuery.of(context).size.height*0.124,8.w,20.h),
                child:  Text(
                  AppLocalizations.of(context)!.login,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration:  InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText:  AppLocalizations.of(context)!.userEmail,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration:  InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.password,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.025),
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child:  ReUseAbleText(text:'Forgot Password',
            //     style: appstyle(14, Colors.black, FontWeight.normal),
            //   ),
            // ),
            Container(
                height: MediaQuery.of(context).size.height*0.062,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.black
                    )
                  ),
                  child:  Text(AppLocalizations.of(context)!.login, style: const TextStyle(
                    color: Colors.white,
                  ),),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text
                      );
                      mainScreenNotifier.pageIndex = 4;
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Text (AppLocalizations.of(context)!.noAccount),
                TextButton(
                  child:  ReUseAbleText(
                    text: AppLocalizations.of(context)!.signup,
                    style: appstyle(12, Colors.black, FontWeight.bold),
                  ),
                  onPressed: () {
                    mainScreenNotifier.pageIndex = 6;
                  },
                )
              ],
            ),
          ],
        ));
  }
}
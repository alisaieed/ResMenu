import 'package:firebase_auth/firebase_auth.dart';

Future<void> loginUser(String email, String password) async {

  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
    // Re-throw the exception to be caught by FutureBuilder
    throw e;
  }
}
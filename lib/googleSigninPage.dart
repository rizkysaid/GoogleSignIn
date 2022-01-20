// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _checkUserLogin() {
    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => AuthHomePage()));
      Fluttertoast.showToast(
          msg: 'Kamu sudah login', toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signInGoogle() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          // Navigator.pop(context);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AuthHomePage()));
          Fluttertoast.showToast(
              msg: 'Berhasil Login', toastLength: Toast.LENGTH_LONG);
        } else {
          Fluttertoast.showToast(
              msg: 'Failed to login : Firebase User return null',
              toastLength: Toast.LENGTH_LONG);
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
            msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(), toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _checkUserLogin();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign In With Google'),
              ElevatedButton(
                onPressed: () {
                  signInGoogle();
                },
                child: const Text('Sign In'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

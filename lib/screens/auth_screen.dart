import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_care/routes/routes.dart';

import '../auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setState(() {
          _auth.currentUser!.uid == 'Goc6OhDmQgfYSRPiZUnlAniCCVB3'
              ? Navigator.of(context)
                  .pushReplacementNamed(MyRoutes.adminDashboard)
              : Navigator.of(context).pushReplacementNamed(MyRoutes.home);
          _isLoading = false;
        });
      } else {
        setState(() {
          Navigator.of(context).pushReplacementNamed(MyRoutes.authScreenRoute);
          _isLoading = false;
        });
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!
                .uid) // when we use add then it will generate its own id but here we can make our own id like here i use user id
            .set({
          // in the document we can add data
          'username': username,
          'email': email,
          'userId': authResult.user!.uid,
          'isDone': false,
        });
      }
    } on PlatformException catch (err) {
      print(err);
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      if (err.toString().contains("no user record")) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text(
                "No User Record Found, Please check your credentials."),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else if (err.toString().contains("already in use")) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content:
                const Text("Email already in use, Please try another one."),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else if (err.toString().contains("network error")) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text("Please check your internet connection."),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else if (err.toString().contains("password is invalid")) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text("Password is incorrect."),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        //  ScaffoldMessenger.of(ctx).showSnackBar(
        //   SnackBar(
        //     content: Text(err.toString()),
        //     backgroundColor: Theme.of(ctx).errorColor,
        //   ),
        // );
        print(err);
      }
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/screens/admin_dashboard.dart';
import 'package:health_care/screens/home.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return;
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    FirebaseAuth.instance.currentUser!.uid ==
                            'Goc6OhDmQgfYSRPiZUnlAniCCVB3'
                        ? const AdminDashboard()
                        : const Home(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,

        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.025),
              child: Text(
                'WELCOME',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: size.height * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Hero(
                tag: 'login',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text(
                      'Health Care',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.08),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Text(
              'Developed by ODIWS',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

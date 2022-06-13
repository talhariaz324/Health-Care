import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/screens/admin_dashboard.dart';
import 'package:health_care/screens/home.dart';

import 'package:splash_screen_view/SplashScreenView.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
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
              child: SplashScreenView(
                navigateRoute: FirebaseAuth.instance.currentUser!.uid ==
                        'Goc6OhDmQgfYSRPiZUnlAniCCVB3'
                    ? AdminDashboard()
                    : Home(),
                duration: 4800,
                imageSize: 330,
                imageSrc: 'assets/images/logo.png',
                text: "Health Care",
                textType: TextType.ColorizeAnimationText,
                textStyle: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor,
                ],
                backgroundColor: Theme.of(context).backgroundColor,
              ),
            ),
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

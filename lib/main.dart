import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_care/provider/img_provider.dart';
import 'package:health_care/provider/new_services.dart';
import 'package:health_care/routes/routes.dart';
import 'package:health_care/screens/admin_dashboard.dart';
import 'package:health_care/screens/admin_order_details.dart';
import 'package:health_care/screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/screens/forgot_password.dart';
import 'package:health_care/screens/home.dart';
import 'package:health_care/screens/splash_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewServices(),),
        // ChangeNotifierProvider(create: (context) => ImgProvider(),),
      ],
      child:    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
              textTheme: GoogleFonts.libreBaskervilleTextTheme(
                  // Theme.of(context).textTheme,

                  ),
              backgroundColor: const Color.fromRGBO(224, 239, 220,1),
              cardColor: const Color.fromRGBO(15, 149, 186, 1),
              hintColor: Colors.white,
              primaryColor: const Color.fromRGBO(6, 115, 186, 1),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme:
                  const ColorScheme.light(secondary: Color.fromRGBO(87, 184, 70, 1),),
              appBarTheme: const AppBarTheme(
                color: Colors.white,
                elevation: 0,
                iconTheme:
                    IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
                titleTextStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // fontFamily: ,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            routes: {
            MyRoutes.home: (context) => const Home(),
            MyRoutes.authScreenRoute: (context) => const AuthScreen(),
            MyRoutes.forgotPassRoute: (context) => const ForgotPassWord(),
            MyRoutes.adminDashboard: (context) => const AdminDashboard(),
            MyRoutes.adminOrderDetail: (context) => const OrderAdminDetails(),

            },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot userSnapshot) {
            if (userSnapshot.hasData) {
              return   const MySplashScreen();
            }
            return  const AuthScreen();
          }),
    ),

    );
}
}


/* 
1) Get Services to admin and add delete option DONE
2) Get Services to home from firebase now DONE
3) add submit button logic
4) Apply logic for getting prescription
5) Apply logic to live location
6) Get in pending and task done status in admin with all details too
*/
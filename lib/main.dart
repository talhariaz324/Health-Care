import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
            return  const AdminDashboard();
          }),
    ),

    );
}
}


/* I done Auth. But there is error in console "Local module descriptor class for com.google.android.gms.providerinstaller.dynamite not found."
   Most probably, my firebase is not configure rightly. So if you are still facing the same issue then configure it again. and search for its solution 
   
   Forgot password field removes text when we down the keyboard.
   When wrong user enter email then snackbar*/
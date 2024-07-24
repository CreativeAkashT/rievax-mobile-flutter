import 'package:flutter/material.dart';
import 'package:rievax/screens/auth/login_screen.dart';
import 'package:rievax/screens/auth/otp_verification_screen.dart';
import 'package:rievax/screens/auth/registration_screen.dart';
import 'package:rievax/screens/auth/reset_password_screen.dart';
import 'package:rievax/screens/auth/reset_password_verification_screen.dart';
import 'package:rievax/screens/home_screen.dart';
import 'package:rievax/screens/splash_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'utils/constants.dart' as constants;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    constants.mq = MediaQuery.of(context).size;
    var primaryColor = const Color(0xff1157AD);
    var primaryColorMaterial =
        MaterialStateProperty.all<Color>(const Color(0xff1157AD));

    return MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white)),
            drawerTheme: DrawerThemeData(backgroundColor: primaryColor),
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(color: Colors.white),
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        primaryColor), // Set the color of the focused border here
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    backgroundColor: primaryColorMaterial,
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)))),
        home: const SplashScreen());
  }
}

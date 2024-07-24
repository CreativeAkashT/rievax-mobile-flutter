import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rievax/models/response/login_response.dart';
import 'package:rievax/screens/auth/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rievax/screens/home_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(const Duration(seconds: 3), () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      constants.user = await constants.getUserFromSharedPreferences();
      CustomHttpClient.init();

      try {
        http.Response response = await CustomHttpClient.get("/user/check-token");
        LoginResponse responseModel =
            LoginResponse.fromJson(jsonDecode(response.body));
        await constants.saveUserToLocal(responseModel.data?.user);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } catch (e) {
        print('Exception: $e');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/images/splash_screen.png"),
    );
  }
}

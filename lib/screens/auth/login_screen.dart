import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rievax/models/response/login_response.dart';
import 'package:rievax/screens/auth/registration_screen.dart';
import 'package:rievax/screens/auth/reset_password_screen.dart';
import 'package:rievax/screens/home_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;
import 'package:rievax/widgets/circular_progress.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;

  void startLoading() =>
      setState(() {
        _isLoading = true;
      });

  void stopLoading() =>
      setState(() {
        _isLoading = false;
      });

  void login(context) async {
    var email = emailController.text.toString();
    var password = passwordController.text.toString();
    if (email.isEmpty) {
      constants.showToast("Please enter email");
      return;
    }
    if (password.isEmpty) {
      constants.showToast("Please enter password");
      return;
    }
    try {
      startLoading();
      http.Response response = await CustomHttpClient.post("/user/login",
          body: {
            'email': email,
            'password': password
          });
      LoginResponse responseModel =
      LoginResponse.fromJson(jsonDecode(response.body));
      constants.saveUserToLocal(responseModel.data?.user);
      constants.showToast("Logged in Successfully!!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (e.toString() == "Email not verified") {
        bool success = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(email: email)),
        );
        if (success == true) {
          constants.showToast("Account verified successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return;
        } else {
          constants.showToast("Verification Cancelled");
        }
      }
      constants.showToast(e.toString());
    }
    stopLoading();
  }

  void openResetPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = constants.mq;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: mq.height * 0.2,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: mq.height * .07,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: _isLoading
                      ? const CircularProgress()
                      : const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  openResetPasswordPage();
                },
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Text("Reset Password"),
                ),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const RegistrationScreen()),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

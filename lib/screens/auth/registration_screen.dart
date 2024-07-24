import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rievax/screens/auth/login_screen.dart';
import 'package:rievax/screens/auth/otp_verification_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;

import '/widgets/circular_progress.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void startLoading() => setState(() {
        _isLoading = true;
      });

  void stopLoading() => setState(() {
        _isLoading = false;
      });

  void register(context) async {
    var name = nameController.text.toString();
    var email = emailController.text.toString();
    var password = passwordController.text.toString();
    var confirmPassword = confirmPasswordController.text.toString();

    if (name.isEmpty) { constants.showToast("Please enter name"); return; }
    if (email.isEmpty) { constants.showToast("Please enter email"); return; }
    if (password.isEmpty) { constants.showToast("Please enter password"); return; }
    if (confirmPassword.isEmpty) { constants.showToast("Please enter confirm password"); return; }
    if (password != confirmPassword) { constants.showToast("Password and Confirm Password must be same."); return; }
    try {
      startLoading();
      http.Response response =
          await CustomHttpClient.post("/user/register", body: {
        'name': name,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword
      });
      bool success = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(email: email)),
      );
      if (success == true) {
        constants.showToast("Account created successfully. Please Login");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        constants.showToast("Something went wrong!!");
      }
    } catch (e) {
      constants.showToast(e.toString());
      print(e.toString());
    }
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    var mq = constants.mq;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: mq.height * 0.2,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
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
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
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
                    register(context);
                  },
                  child: _isLoading
                      ? const CircularProgress()
                      : const Text(
                          "Register",
                          style: TextStyle(fontSize: 20),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Login",
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

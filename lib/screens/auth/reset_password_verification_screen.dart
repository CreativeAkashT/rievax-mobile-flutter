import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:rievax/screens/auth/login_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;
import 'package:rievax/widgets/circular_progress.dart';
import 'package:http/http.dart' as http;

class ResetPasswordVerificationScreen extends StatefulWidget {
  final String email;

  const ResetPasswordVerificationScreen({super.key, required this.email});

  @override
  State<ResetPasswordVerificationScreen> createState() =>
      _ResetPasswordVerificationScreenState();
}

class _ResetPasswordVerificationScreenState
    extends State<ResetPasswordVerificationScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late var email;
  var _code = "";
  bool _isLoading = false;

  void resetPassword() async {
    var password = passwordController.text.toString();
    var confirmPassword = confirmPasswordController.text.toString();
    setState(() {
      _isLoading = true;
    });
    try {
      http.Response response = await CustomHttpClient.post("/user/reset-password-submit",
          body: {
            'email': email,
            'otp': _code,
            'password': password,
            'confirm_password': confirmPassword
          });
      constants.showToast("Password reset successfully!!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print(e.toString());
      constants.showToast(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            OtpTextField(
              numberOfFields: 6,
              borderColor: constants.primaryColor,
              showFieldAsBox: true,
              onSubmit: (String code) {
                _code = code;
                print(code);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: constants.mq.height * .07,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                child: _isLoading
                    ? const CircularProgress()
                    : const Text(
                  "Reset",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rievax/screens/auth/reset_password_verification_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;
import 'package:rievax/widgets/circular_progress.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var _isLoading = false;
  TextEditingController emailController = TextEditingController();

  void sendOtp() async {
    var email = emailController.text.toString();
    if (email.isEmpty) {
      constants.showToast("Please enter email");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      http.Response response = await CustomHttpClient.post(
          "/user/reset-password",
          body: {'email': email});
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResetPasswordVerificationScreen(
                    email: email,
                  )));
    } catch (e) {
      constants.showToast(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
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
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter Email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: constants.mq.height * .07,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  sendOtp();
                },
                child: _isLoading
                    ? const CircularProgress()
                    : const Text(
                        "Continue",
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

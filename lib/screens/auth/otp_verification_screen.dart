import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rievax/screens/home_screen.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import '/utils/constants.dart' as constants;
import '/widgets/circular_progress.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:rievax/utils/constants.dart' as constants;

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool _isLoading = false;
  bool _isResending = false;
  String _code = "";
  late String email;

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  void startLoading() => setState(() {
        _isLoading = true;
      });

  void stopLoading() => setState(() {
        _isLoading = false;
      });

  void verifyCode() async {
    startLoading();
    try {
      http.Response response = await CustomHttpClient.post(
          "/user/register/verify-otp",
          body: {'email': email, 'otp': _code});
      Navigator.pop(context, true);
    } catch (e) {
      print(e.toString());
      constants.showToast(e.toString());
    }
    stopLoading();
  }
  void resendOtp() async {
    setState(() {
      _isResending = true;
    });
    try {
      http.Response response = await CustomHttpClient.post(
          "/user/resend-otp",
          body: {'email': email});
      constants.showToast("OTP Sent Successfully!!");
    } catch (e) {
      print(e.toString());
      constants.showToast(e.toString());
    }
    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = constants.mq;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * 0.12,
            width: mq.width * .3,
            right: mq.width * .35,
            child: Image.asset("assets/images/logo.png"),
          ),
          Positioned(
            top: mq.height * 0.28,
            left: mq.width * 0.05,
            right: mq.width * 0.05,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "One final step! We need to verify your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please check your inbox for verification code sent to $email",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: constants.primaryColor,
                    showFieldAsBox: true,
                    onSubmit: (String code) {
                      _code = code;
                      print(code);
                    },
                  ),

                  const SizedBox(height: 35),
                  SizedBox(
                    height: mq.height * .06,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        verifyCode();
                      },
                      child: _isLoading
                          ? const CircularProgress()
                          : const Text("Verify"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: ()=>resendOtp(),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _isResending
                          ? const CircularProgress(size: 15,)
                          : const Text("Resend OTP"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.center,
                    child:
                        Text("Can't find it? Please check your spam folder."),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

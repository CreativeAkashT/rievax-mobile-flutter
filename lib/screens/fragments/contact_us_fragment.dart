import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactUsFragment extends StatefulWidget {
  const ContactUsFragment({super.key});

  @override
  State<ContactUsFragment> createState() => _ContactUsFragmentState();
}

class _ContactUsFragmentState extends State<ContactUsFragment> {
  bool _isLoading = false;
  String address = "", mobile = "", email1 = "", email2 = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent();
  }

  dynamic getPageContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    const TextStyle headingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    const TextStyle subHeadingStyle = TextStyle(
      fontSize: 18,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Contact Us",
                style: TextStyle(
                    color: constants.primaryColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Image.asset("assets/images/ic_location.png",
                    height: 35, width: 35),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Address",
                  style: headingStyle,
                )
              ],
            ),
            Text(
              address,
              style: subHeadingStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Image.asset("assets/images/ic_email.png",
                    height: 35, width: 35),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Phone",
                  style: headingStyle,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                constants.openUrl("tel:$mobile");
              },
              child: Text(
                mobile,
                style: subHeadingStyle,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Image.asset("assets/images/ic_phone.png",
                    height: 35, width: 35),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Email",
                  style: headingStyle,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                constants.openUrl("mailto:$email1");
              },
              child: Text(
                email1,
                style: subHeadingStyle,
              ),
            ),
            GestureDetector(
              onTap: () {
                constants.openUrl("mailto:$email2");
              },
              child: Text(
                email2,
                style: subHeadingStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      http.Response response = await CustomHttpClient.get("/contact-us");
      var resJson = jsonDecode(response.body);
      var data = resJson["data"];
      setState(() {
        address = data["address"];
        mobile = data["mobile"];
        email1 = data["email1"];
        email2 = data["email2"];
        _isLoading = false;
      });
    } catch (e) {
      constants.showToast(e.toString());
      print("Exception: $e");
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;

class AboutUsFragment extends StatefulWidget {
  const AboutUsFragment({super.key});

  @override
  State<AboutUsFragment> createState() => _AboutUsFragmentState();
}

class _AboutUsFragmentState extends State<AboutUsFragment> {
  bool _isLoading = true;
  String aboutUsContent = "";
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
    return SingleChildScrollView(
      child: Column(children: [
        const Center(
          child: Text(
            "About Us",
            style: TextStyle(
                color: constants.primaryColor,
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            aboutUsContent,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15),
          ),
        )
      ]),
    );
  }
  void loadData() async {
    try{
      http.Response response = await CustomHttpClient.get("/about-us");
      var resJson = jsonDecode(response.body);
      setState(() {
        aboutUsContent = resJson["data"]["content"];
        _isLoading = false;
      });
    }catch(e) {
      constants.showToast(e.toString());
      print("Exception: $e");
    }
  }
}

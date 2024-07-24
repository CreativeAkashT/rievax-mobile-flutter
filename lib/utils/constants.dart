library rievax.constants;

import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rievax/utils/constants.dart' as constants;

var mq;
const primaryColor = Color(0xff1157AD);

const domainName = "https://rievax.gmaxmart.in";
// const domainName = "https://greek-jurisdiction-instruments-tommy.trycloudflare.com";
const apiBaseUrl = "$domainName/api";

User? user;

void showToast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      fontSize: 16.0);
}

void openUrl(url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    showToast("Could not launch the url.");
  }
}

Future<User?> getUserFromSharedPreferences() async {
  try {
    var prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      User user = User.fromJson(jsonMap);
      return user;
    } else {
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}

Future saveUserToLocal(User? user) async {
  var existingData = await getUserFromSharedPreferences();
  if (existingData!=null && existingData.token != null && user != null && user.token==null) {
    user.token = existingData.token;
  }
  constants.user = user;
  CustomHttpClient.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user", jsonEncode(user?.toJson()));
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rievax/screens/auth/login_screen.dart';
import 'package:rievax/screens/fragments/about_us_fragment.dart';
import 'package:rievax/screens/fragments/contact_us_fragment.dart';
import 'package:rievax/screens/fragments/home_fragment.dart';
import 'package:rievax/utils/CustomHttpClient.dart';
import 'package:rievax/utils/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedTab = 0;
  StatefulWidget _selectedFragment = const HomeFragment();

  void _onItemTapped(item) => setState(() {
        _selectedTab = item;
        switch (item) {
          case 0:
            _selectedFragment = const HomeFragment();
            break;
          case 1:
            _selectedFragment = const AboutUsFragment();
            break;
          case 2:
            _selectedFragment = const ContactUsFragment();
            break;
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(1), // Adjust padding as needed
          child: Image.asset(
            'assets/images/logo.png',
            // Replace 'your_image.png' with your image asset path
            height: 50, // Adjust height as needed
            width: 50, // Adjust width as needed
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.white54,
              height: 1.0,
            )),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(1), // Adjust padding as needed
        //     child: Image.asset(
        //       'assets/images/logo.png',
        //       // Replace 'your_image.png' with your image asset path
        //       height: 100, // Adjust height as needed
        //       width: 100, // Adjust width as needed
        //     ),
        //   ),
        // ],
      ),
      drawer: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(80)),
        child: Drawer(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70, bottom: 20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/logo.png",
                        ),
                        radius: 40,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        constants.user?.name ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title:
                    Text('Home', style: Theme.of(context).textTheme.bodyLarge),
                selected: _selectedTab == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('About Us',
                    style: Theme.of(context).textTheme.bodyLarge),
                selected: _selectedTab == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Contact Us',
                    style: Theme.of(context).textTheme.bodyLarge),
                selected: _selectedTab == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Logout',
                    style: Theme.of(context).textTheme.bodyLarge),
                selected: _selectedTab == 3,
                onTap: () {
                  logout(context);
                },
              ),
              const Divider(),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20.0)),
                margin: const EdgeInsets.fromLTRB(7, 10, 7, 20),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white54,
                              size: 20,
                            ),
                          ),
                          TextSpan(
                              text: "Delete Account",
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  // title: const Text('Delete Account',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         color: Colors.red,
                  //
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 20)),
                  selected: _selectedTab == 3,
                  onTap: () {
                    // logout(context);
                    _dialogBuilder(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: _selectedFragment,
    );
  }

  void logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            style: TextStyle(color: Colors.black),
            'This action is irreversible.\n If you want to you login again you have to create a new account.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.red),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.black12),
              child: const Text('Confirm'),
              onPressed: () {
                deleteAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteAccount() async {
    try {
      http.Response response =
          await CustomHttpClient.post("/delete-account", body: {});
      var resJson = jsonDecode(response.body);
      constants.showToast("Account deleted Successfully!!");
      logout(context);
    } catch (e) {
      constants.showToast(e.toString());
    }
  }
}

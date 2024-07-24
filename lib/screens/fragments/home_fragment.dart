import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rievax/screens/webview_screen.dart';
import 'package:rievax/utils/constants.dart' as constants;

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    double radius =
        mq.size.shortestSide * 0.25; // Adjust the multiplier as needed

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // constants.openUrl(constants.user?.createTicketLink);
                    if(constants.user?.createTicketLink==null){
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          WebviewScreen(url: constants.user?.createTicketLink ?? "")),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: constants.primaryColor,
                    radius: radius,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      // Adjust the padding as needed
                      child: Image.asset(
                        "assets/images/ic_open_ticket.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Open a Ticket",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    constants.openUrl("tel:${constants.user?.contactMobile}");
                  },
                  child: CircleAvatar(
                    backgroundColor: constants.primaryColor,
                    radius: radius,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      // Adjust the padding as needed
                      child: Image.asset(
                        "assets/images/ic_headphones.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Call to Rievax",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

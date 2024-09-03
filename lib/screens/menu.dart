import 'package:flutter/material.dart';
import 'package:test/components/menu_list2.dart';
import 'package:test/screens/transfer.dart';
import 'package:test/screens/cancle.dart';
import 'package:test/screens/goodIssue.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:test/screens/login.dart';
import 'package:test/screens/reprint.dart';

class Menu extends StatefulWidget {
  static String routeName = "/menu";
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<Menu> {
  bool containerVisible = true;

  @override
  void initState() {
    super.initState();
  }

  void logoutDialog() {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
            image: Image.asset(
              'assets/men_wearing_jacket.gif',
              fit: BoxFit.cover,
            ),
            title: Text(
              'LOGOUT',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
            description: Text(
              'Are your sure logout?',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            entryAnimation: EntryAnimation.RIGHT,
            onOkButtonPressed: () {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            },
            onCancelButtonPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.of(context).pop();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage("assets/B2.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.75), BlendMode.dstATop),
        )),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              SizedBox(height: 10),
              Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "GI",
                  imageIcon: Image.asset(
                    "assets/gi.png",
                    width: 50,
                    height: 50,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GoodIssue()))
                  },
                ),
              ),
               Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "TR",
                  imageIcon: Image.asset(
                    "assets/exchange.png",
                    width: 50,
                    height: 50,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Transfer()))
                  },
                ),
              ),
              Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "Cancle GI",
                  imageIcon: Image.asset(
                    "assets/cancelgi.png",
                    width: 50,
                    height: 50,
                  ),
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cancle()))
                  },
                ),
              ),
              Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "Re-Print",
                  imageIcon: Image.asset(
                    "assets/canclesticker.png",
                    width: 50,
                    height: 50,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Reprint()))
                  },
                ),
              ),
              Visibility(
                  visible: containerVisible,
                  child: MenuList2(
                    text: "Log Out",
                    imageIcon: Image.asset(
                      "assets/logout.png",
                      width: 50,
                      height: 50,
                    ),
                    press: () => {logoutDialog()},
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

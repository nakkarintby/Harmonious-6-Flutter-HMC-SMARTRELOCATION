import 'package:flutter/material.dart';
import 'package:test/components/menu_list2.dart';
import 'package:test/screens/goods_received.dart';
import 'package:test/screens/menu1.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), BlendMode.dstATop),
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
                    width: 65,
                    height: 55,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GoodReceived()))
                  },
                ),
              ),
              Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "Cancle GI",
                  imageIcon: Image.asset(
                    "assets/cancelgi.png",
                    width: 65,
                    height: 55,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Menu1()))
                  },
                ),
              ),
              Visibility(
                visible: containerVisible,
                child: MenuList2(
                  text: "Re-Print",
                  imageIcon: Image.asset(
                    "assets/canclesticker.png",
                    width: 65,
                    height: 55,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Menu1()))
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

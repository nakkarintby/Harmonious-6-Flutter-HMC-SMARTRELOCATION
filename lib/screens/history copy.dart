import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/resvalidatepalletitem.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Palletitem test = Palletitem();
  Palletitem test2 = Palletitem();
  List<Palletitem> list = [];
  String documentId = "";
  String configs = '';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    onload();
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      configs = prefs.getString('configs');
      documentId = prefs.getString('historydocid');
    });
  }

  Future<void> onload() async {
    /*setState(() {
      test.palletNo = '';
      test.lot = 'no data item';
      test.palletNo = '';
      list.add(test);
    });*/
    setState(() {
      test.palletNo = '1';
      test.lot = 'label1';
      test.weight = 123;
      test2.palletNo = '2';
      test2.lot = 'label2';
      test2.weight = 456;
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'History',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Form(
                    child: Column(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow[900],
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Text('No'),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow[900],
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Text('lot'),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow[900],
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Text('weight'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                for (var data in list)
                  buildHistoryRow(
                      '${data.palletNo}', '${data.lot}', '${data.palletNo}'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12),
                      Container(height: 2, color: Colors.redAccent),
                      SizedBox(height: 9),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ])))));
  }
}

Widget buildHistoryRow(String palletNo, String lot, String weight) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        Container(height: 2, color: Colors.redAccent),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            //CircleAvatar(backgroundImage: AssetImage(imageAsset)),
            SizedBox(width: 20),
            Text(palletNo),
            Spacer(),
            SizedBox(width: 10),
            Text(lot),
            Spacer(),
            Text(weight),
            SizedBox(width: 20),
          ],
        ),
      ],
    ),
  );
}

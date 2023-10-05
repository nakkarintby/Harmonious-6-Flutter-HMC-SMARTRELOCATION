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
  Palletitem test3 = Palletitem();
  Palletitem test4 = Palletitem();
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
      test.binId = 1;
      test.lot = 'TP058901';
      test.weight = 750;
      test2.binId = 2;
      test2.lot = 'TC0457184';
      test2.weight = 1250;
      test3.binId = 3;
      test3.lot = 'TS487198';
      test3.weight = 550;
      test4.binId = 4;
      test4.lot = 'CP894141';
      test4.weight = 380;
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
      list.add(test);
      list.add(test2);
    });
  }

  DataTable _createDataTable() {
    return DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.grey[200]!,
        ),
        columnSpacing: 5,
        //border: TableBorder.all(width: 1),
        columns: _createColumns(),
        rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Expanded(
              child: (Text('Pallet No.',
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))))),
      DataColumn(
          label: Expanded(
              child: Text('Qty',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)))),
    ];
  }

  List<DataRow> _createRows() {
    return list
        .map((list) => DataRow(
                color: MaterialStateColor.resolveWith((states) {
                  return list.binId! % 2 == 0
                      ? Colors.grey[200]!
                      : Colors.transparent; //make tha magic!
                }),
                cells: [
                  DataCell(Container(
                      width: 160, //SET width
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            list.lot.toString(),
                            textAlign: TextAlign.start,
                          )))),
                  DataCell(
                    list.binId! % 2 == 0
                        ? Align(
                            alignment: Alignment.center,
                            child: Text(
                              list.weight.toString(),
                              textAlign: TextAlign.start,
                            ))
                        : Align(
                            alignment: Alignment.center,
                            child: Text(
                              list.weight.toString(),
                              textAlign: TextAlign.start,
                            )),
                  ),
                ]))
        .toList();
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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              SizedBox(height: 25),
              Center(
                  child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                height: MediaQuery.of(context).size.height / 1.55,
                child: SingleChildScrollView(
                    child: Column(children: [
                  _createDataTable(),
                ])),
              )),
              SizedBox(height: 25),
              Container(
                width: 100.0,
                height: 45.0,
                child: new RaisedButton(
                  color: Colors.red,
                  child: const Text('Back',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ])));
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

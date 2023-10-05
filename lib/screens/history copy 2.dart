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
      test.lot = 'label1';
      test.weight = 123;
      test2.binId = 2;
      test2.lot = 'label2';
      test2.weight = 456;
      test3.binId = 3;
      test3.lot = 'label3';
      test3.weight = 789;
      test4.binId = 4;
      test4.lot = 'label4';
      test4.weight = 999;
      list.add(test);
      list.add(test2);
      list.add(test3);
      list.add(test4);
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
              child: (Text('No',
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))))),
      DataColumn(
          label: Expanded(
              child: Text('Detail',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)))),
      DataColumn(
          label: Expanded(
              child: Text('Result',
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
                      width: 100, //SET width
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            list.binId.toString(),
                            textAlign: TextAlign.start,
                          )))),
                  DataCell(Container(
                      width: 160, //SET width
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            list.lot!,
                            textAlign: TextAlign.center,
                          )))),
                  DataCell(
                    list.binId! % 2 == 0
                        ? Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30.0,
                            ))
                        : Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 30.0,
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
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: SingleChildScrollView(
                    child: Column(children: [
                  _createDataTable(),
                ])),
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

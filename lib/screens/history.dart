import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/listpallet.dart';
import 'package:test/class/resvalidatepalletitem.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<ListPallet> list = [];
  String configs = '';
  String accessToken = "";
  String dono = "";
  String plandate = "";
  String matno = "";
  String batch = "";
  String matdesc = "";
  late Timer timer;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  void showErrorDialog(String error) {
    //MyWidget.showMyAlertDialog(context, "Error", error);
    alertDialog(error, 'Error');
  }

  void showSuccessDialog(String success) {
    //MyWidget.showMyAlertDialog(context, "Success", success);
    alertDialog(success, 'Success');
  }

  void alertDialog(String msg, String type) {
    Icon icon = Icon(Icons.info_outline, color: Colors.lightBlue);
    switch (type) {
      case "Success":
        icon = Icon(Icons.check_circle_outline, color: Colors.lightGreen);
        break;
      case "Error":
        icon = Icon(Icons.error_outline, color: Colors.redAccent);
        break;
      case "Warning":
        icon = Icon(Icons.warning_amber_outlined, color: Colors.orangeAccent);
        break;
      case "Infomation":
        icon = Icon(Icons.info_outline, color: Colors.lightBlue);
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          timer = Timer(Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop();
          });

          return AlertDialog(
            title: Row(children: [icon, Text(" " + type)]),
            content: Text(msg),
          );
        }).then((val) {
      if (timer.isActive) {
        timer.cancel();
      }
    });
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      configs = prefs.getString('configs');
      dono = prefs.getString('dono');
      plandate = prefs.getString('plandate');
      matno = prefs.getString('matno');
      batch = prefs.getString('batch');
      matdesc = prefs.getString('matdesc');
    });
    await onload();
  }

  Future<void> onload() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;

      var url = Uri.parse('http://' +
          configs +
          '/API/api/LoadTracking/SelectLTLoadedHistList/' +
          dono +
          '/' +
          plandate +
          '/' +
          matno +
          '/' +
          batch);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          list = (json.decode(response.body) as List)
              .map((data) => ListPallet.fromJson(data))
              .toList();
        });

        if (list.length == 0) {
          //MyWidget.showMyAlertDialog(context, "Error", "Data not found");
          showErrorDialog('ไม่พบข้อมูลการ Load สินค้า ' + matdesc);
        }
      } else {
        showErrorDialog('Error SelectLTLoadedHistList');
      }
    } catch (e) {
      showErrorDialog('Error occured while SelectLTLoadedHistList');
    }
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
                  return list.quantity! % 2 == 0
                      ? Colors.transparent
                      : Colors.grey[200]!; //make tha magic!
                }),
                cells: [
                  DataCell(Container(
                      width: 160, //SET width
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            list.palletno.toString(),
                            textAlign: TextAlign.start,
                          )))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: Text(
                        list.quantity.toString(),
                        textAlign: TextAlign.start,
                      ))),
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

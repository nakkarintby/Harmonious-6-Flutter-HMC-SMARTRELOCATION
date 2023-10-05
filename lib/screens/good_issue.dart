import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/resvalidatedocument.dart';
import 'package:test/class/resvalidatelocation.dart';
import 'package:test/class/resvalidatepalletitem.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:test/constants.dart';
import 'package:test/mywidget.dart';
import 'package:test/screens/history.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';

class GoodIssue extends StatefulWidget {
  const GoodIssue({Key? key}) : super(key: key);

  @override
  _GoodIssueState createState() => _GoodIssueState();
}

class _GoodIssueState extends State<GoodIssue> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController matNumberController = TextEditingController();
  TextEditingController matDescController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController palletnumberController = TextEditingController();
  TextEditingController orderQtyController = TextEditingController();
  TextEditingController remainQtyController = TextEditingController();
  TextEditingController packingQtyController = TextEditingController();

  bool documentNumberVisible = false;
  bool matNumberVisible = false;
  bool detailVisible = false;
  bool buttonVisible = false;

  bool documentNumberReadonly = false;
  bool matNumberReadonly = false;
  bool matDescReadonly = false;
  bool lotReadonly = false;
  bool palletnumberReadonly = false;
  bool orderQtyReadonly = false;
  bool remainQtyReadonly = false;
  bool packingQtyReadonly = false;

  Color documentNumberColor = Color(0xFFFFFFFF);
  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletnumberColor = Color(0xFFFFFFFF);
  Color orderQtyColor = Color(0xFFFFFFFF);
  Color remainQtyColor = Color(0xFFFFFFFF);
  Color packingQtyColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool historyEnabled = false;
  bool submitEnabled = false;

  String documentNumberInput = '';
  String matNumberInput = '';
  String matDescInput = '';
  String lotInput = '';
  String palletnumberInput = '';
  String orderQtyInput = '';
  String remainQtyInput = '';
  String packingQtyInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    getSharedPrefs();
    setState(() {
      step = 1;
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> getDeviceInfo() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    var ans = 'Android ' +
        release.toString() +
        ' (SDK ' +
        sdkInt.toString() +
        '), ' +
        manufacturer.toString() +
        ' ' +
        model.toString();

    setState(() {
      deviceInfo = ans;
    });
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      configs = prefs.getString('configs');
    });
  }

  void setVisible() {
    if (step == 1) {
      setState(() {
        documentNumberVisible = true;
        matNumberVisible = false;
        detailVisible = false;
        buttonVisible = false;
      });
    } else if (step == 2) {
      setState(() {
        documentNumberVisible = true;
        matNumberVisible = true;
        detailVisible = false;
        buttonVisible = true;
      });
    } else if (step == 3) {
      setState(() {
        documentNumberVisible = true;
        matNumberVisible = true;
        detailVisible = true;
        buttonVisible = true;
      });
    }
  }

  void setReadOnly() {
    if (step == 1) {
      setState(() {
        documentNumberReadonly = false;
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        orderQtyReadonly = false;
        remainQtyReadonly = false;
        packingQtyReadonly = false;

        backEnabled = false;
        historyEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        orderQtyReadonly = false;
        remainQtyReadonly = false;
        packingQtyReadonly = false;

        backEnabled = true;
        historyEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 3) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = true;
        matDescReadonly = true;
        lotReadonly = true;
        palletnumberReadonly = true;
        orderQtyReadonly = true;
        remainQtyReadonly = true;
        packingQtyReadonly = true;

        backEnabled = true;
        historyEnabled = true;
        submitEnabled = true;
      });
    }
  }

  void setColor() {
    if (step == 1) {
      setState(() {
        documentNumberColor = Color(0xFFFFFFFF);
        matNumberColor = Color(0xFFFFFFFF);
        matDescColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        orderQtyColor = Color(0xFFFFFFFF);
        remainQtyColor = Color(0xFFFFFFFF);
        packingQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFFFFFFF);
        matDescColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        orderQtyColor = Color(0xFFFFFFFF);
        remainQtyColor = Color(0xFFFFFFFF);
        packingQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        matDescColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletnumberColor = Color(0xFFEEEEEE);
        orderQtyColor = Color(0xFFEEEEEE);
        remainQtyColor = Color(0xFFEEEEEE);
        packingQtyColor = Color(0xFFEEEEEE);
      });
    }
  }

  void setText() {
    if (step == 1) {
      setState(() {
        documentNumberController.text = '';
        matNumberController.text = '';
        matDescController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
        orderQtyController.text = '';
        remainQtyController.text = '';
        packingQtyController.text = '';
      });
    } else if (step == 2) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = '';
        matDescController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
        orderQtyController.text = '';
        remainQtyController.text = '';
        packingQtyController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = matNumberInput;
        matDescController.text = matDescInput;
        lotController.text = lotInput;
        palletnumberController.text = palletnumberInput;
        orderQtyController.text = orderQtyInput;
        remainQtyController.text = remainQtyInput;
        packingQtyController.text = packingQtyInput;
      });
    }
  }

  void setFocus() {
    if (step == 1) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[0]));
    } else if (step == 2) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[1]));
    } else if (step == 3) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[2]));
    }
  }

  void backStep() {
    setState(() {
      step--;
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
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

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (step == 1) {
      setState(() {
        documentNumberController.text = barcodeScanRes;
      });
      documentNumberCheck();
    } else if (step == 2) {
      setState(() {
        matNumberController.text = barcodeScanRes;
      });
      matNumberCheck();
    } else {
      return;
    }
  }

  Future<void> documentNumberCheck() async {
    setState(() {
      step++;
      documentNumberInput = documentNumberController.text;
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> matNumberCheck() async {
    setState(() {
      step++;
      matNumberInput = matNumberController.text;
      matDescInput = '1';
      lotInput = '2';
      palletnumberInput = '3';
      orderQtyInput = '4';
      remainQtyInput = '5';
      packingQtyInput = '6';
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> setHistoryDocid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('historydocid', documentNumberInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'GI',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.black,
                ),
                onPressed: scanQR)
          ],
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: documentNumberVisible,
                      child: TextFormField(
                        focusNode: focusNodes[0],
                        readOnly: documentNumberReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          documentNumberCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: documentNumberColor,
                          filled: true,
                          hintText: 'Enter Document No.',
                          labelText: 'Document Number',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: documentNumberController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: matNumberVisible,
                      child: TextFormField(
                        focusNode: focusNodes[1],
                        readOnly: matNumberReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          matNumberCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matNumberColor,
                          filled: true,
                          hintText: 'Enter Mat No.',
                          labelText: 'Mat Number',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: matNumberController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: matDescReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matDescColor,
                          filled: true,
                          hintText: 'Enter Mat Desc',
                          labelText: 'Mat Desc',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: matDescController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: lotReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: lotColor,
                          filled: true,
                          hintText: 'Enter Lot',
                          labelText: 'Lot',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: lotController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: palletnumberReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: palletnumberColor,
                          filled: true,
                          hintText: 'Enter Pallet No.',
                          labelText: 'Pallet Number',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: palletnumberController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: orderQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: orderQtyColor,
                          filled: true,
                          hintText: 'Enter Order Qty',
                          labelText: 'Order Qty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: orderQtyController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: remainQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: remainQtyColor,
                          filled: true,
                          hintText: 'Enter Remain Qty',
                          labelText: 'Remain Qty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: remainQtyController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: detailVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: packingQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: packingQtyColor,
                          filled: true,
                          hintText: 'Enter Packing Qty',
                          labelText: 'Packing Qty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: packingQtyController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Visibility(
                  visible: buttonVisible,
                  child: new Center(
                    child: new ButtonBar(
                      mainAxisSize: MainAxisSize
                          .min, // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        Container(
                          width: 70.0,
                          height: 40.0,
                          child: new RaisedButton(
                            color: Colors.blue,
                            child: const Text('Back',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: backEnabled
                                ? () {
                                    backStep();
                                  }
                                : null,
                          ),
                        ),
                        Container(
                          width: 70.0,
                          height: 40.0,
                          child: new RaisedButton(
                            color: Colors.red,
                            child: const Text('History',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: historyEnabled
                                ? () async {
                                    await setHistoryDocid();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => History()));
                                  }
                                : null,
                          ),
                        ),
                        Container(
                          width: 70.0,
                          height: 40.0,
                          child: new RaisedButton(
                            focusNode: focusNodes[2],
                            color: step == 3 ? Colors.green : Colors.blue,
                            child: const Text('Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: submitEnabled
                                ? () {
                                    /*Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Post Complete')));*/
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ))));
  }
}

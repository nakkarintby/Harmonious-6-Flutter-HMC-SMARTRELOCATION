import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/createLoadTracking.dart';
import 'package:test/class/resultSelectChkLoadedFull.dart';
import 'package:test/screens/doDetailGI.dart';
import 'package:test/screens/loadHistoryGI.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';

class Reprint extends StatefulWidget {
  const Reprint({Key? key}) : super(key: key);

  @override
  _ReprintState createState() => _ReprintState();
}

class _ReprintState extends State<Reprint> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController matNumberController = TextEditingController();
  TextEditingController matDescController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bagTypeController = TextEditingController();
  TextEditingController productionDateController = TextEditingController();
  TextEditingController tisiController = TextEditingController();
  TextEditingController labelQtyController = TextEditingController();

  bool matNumberVisible = false;
  bool detailVisible = false;
  bool buttonVisible = false;

  bool matNumberReadonly = false;
  bool matDescReadonly = false;
  bool lotReadonly = false;
  bool weightReadonly = false;
  bool bagTypeReadonly = false;
  bool productionDateReadonly = false;
  bool tisiReadonly = false;
  bool labelQtyReadonly = false;

  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color weightColor = Color(0xFFFFFFFF);
  Color bagTypeColor = Color(0xFFFFFFFF);
  Color productionDateColor = Color(0xFFFFFFFF);
  Color tisiColor = Color(0xFFFFFFFF);
  Color labelQtyColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool submitEnabled = false;

  String matNumberInput = '';
  String matDescInput = '';
  String lotInput = '';
  String weightInput = '';
  String bagTypeInput = '';
  String productionDateInput = '';
  String tisiInput = '';
  String labelQtyInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';
  String accessToken = '';
  String username = '';

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
      accessToken = prefs.getString('token');
    });
  }

  void setVisible() {
    if (step == 1) {
      setState(() {
        matNumberVisible = true;
        detailVisible = false;
        buttonVisible = false;
      });
    } else if (step == 2) {
      setState(() {
        matNumberVisible = true;
        detailVisible = true;
        buttonVisible = true;
      });
    }
  }

  void setReadOnly() {
    if (step == 1) {
      setState(() {
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        weightReadonly = false;
        bagTypeReadonly = false;
        productionDateReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;

        backEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        matNumberReadonly = true;
        matDescReadonly = true;
        lotReadonly = true;
        weightReadonly = true;
        bagTypeReadonly = true;
        productionDateReadonly = true;
        tisiReadonly = true;
        labelQtyReadonly = true;

        backEnabled = true;
        submitEnabled = true;
      });
    }
  }

  void setColor() {
    if (step == 1) {
      setState(() {
        matNumberColor = Color(0xFFFFFFFF);
        matDescColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        matNumberColor = Color(0xFFEEEEEE);
        matDescColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        productionDateColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFEEEEEE);
        labelQtyColor = Color(0xFFEEEEEE);
      });
    }
  }

  void setText() {
    if (step == 1) {
      setState(() {
        matNumberController.text = '';
        matDescController.text = '';
        lotController.text = '';
        weightController.text = '';
        bagTypeController.text = '';
        productionDateController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
      });
    } else if (step == 2) {
      setState(() {
        matNumberController.text = matNumberInput;
        matDescController.text = matDescInput;
        lotController.text = lotInput;
        weightController.text = weightInput;
        bagTypeController.text = bagTypeInput;
        productionDateController.text = productionDateInput;
        tisiController.text = tisiInput;
        labelQtyController.text = labelQtyInput;
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

  Future<void> showProgressLoading(bool finish) async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        progress: 50.0,
        message: "Please wait...",
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    if (finish == false) {
      await pr.show();
    } else {
      await pr.hide();
    }
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
        matNumberController.text = barcodeScanRes;
      });
      matNumberCheck();
    } else {
      return;
    }
  }

  Future<void> matNumberCheck() async {
    await showProgressLoading(false);
    setState(() {
      matNumberController.text =
          'Moplen HP400K|60112405|998|750|KG|08/08/2017|';
    });

    var split = matNumberController.text.split('|');

    setState(() {
      matNumberInput = '999999999';
      matDescInput = split[0];
      lotInput = split[1];
      weightInput = '1500';
      bagTypeInput = '1000';
      productionDateInput = '01-01-66';
      tisiInput = 'tisi';
      labelQtyInput = '5000';
      step++;
    });

    await showProgressLoading(true);
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> submitStep() async {
    await showProgressLoading(false);

    await showProgressLoading(true);
    showSuccessDialog('Post Successful!');
    setState(() {
      step = 1;
    });

    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Reprint',
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
                      visible: matNumberVisible,
                      child: TextFormField(
                        focusNode: focusNodes[0],
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
                        readOnly: weightReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: weightColor,
                          filled: true,
                          hintText: 'Enter Weight',
                          labelText: 'Weight',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: weightController,
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
                        readOnly: bagTypeReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: bagTypeColor,
                          filled: true,
                          hintText: 'Enter BagType',
                          labelText: 'BagType',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: bagTypeController,
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
                        readOnly: productionDateReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: productionDateColor,
                          filled: true,
                          hintText: 'Enter Production Date',
                          labelText: 'Production Date',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: productionDateController,
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
                        readOnly: tisiReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: tisiColor,
                          filled: true,
                          hintText: 'Enter Tisi',
                          labelText: 'Tisi',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: tisiController,
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
                        readOnly: labelQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: labelQtyColor,
                          filled: true,
                          hintText: 'Enter LabelQty',
                          labelText: 'LabelQty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: labelQtyController,
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
                            color: Colors.red,
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
                            focusNode: focusNodes[1],
                            color: step == 2 ? Colors.green : Colors.blue,
                            child: const Text('Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: submitEnabled
                                ? () {
                                    submitStep();
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

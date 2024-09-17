import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/reprintCreate.dart';
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
  TextEditingController palletNoController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController bagTypeController = TextEditingController();
  TextEditingController productionDateController = TextEditingController();
  TextEditingController tisiController = TextEditingController();
  TextEditingController labelQtyController = TextEditingController();

  bool matNumberVisible = false;
  bool matDescVisible = false;
  bool lotVisible = false;
  bool palletNoVisible = false;
  bool weightVisible = false;
  bool unitVisible = false;
  bool bagTypeVisible = false;
  bool productionDateVisible = false;
  bool tisiVisible = false;
  bool labelQtyVisible = false;

  bool buttonVisible = false;

  bool matNumberReadonly = false;
  bool matDescReadonly = false;
  bool lotReadonly = false;
  bool palletNoReadonly = false;
  bool weightReadonly = false;
  bool unitReadonly = false;
  bool bagTypeReadonly = false;
  bool productionDateReadonly = false;
  bool tisiReadonly = false;
  bool labelQtyReadonly = false;

  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletNoColor = Color(0xFFFFFFFF);
  Color weightColor = Color(0xFFFFFFFF);
  Color unitColor = Color(0xFFFFFFFF);
  Color bagTypeColor = Color(0xFFFFFFFF);
  Color productionDateColor = Color(0xFFFFFFFF);
  Color tisiColor = Color(0xFFFFFFFF);
  Color labelQtyColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool submitEnabled = false;

  String matNumberInput = '';
  String matDescInput = '';
  String lotInput = '';
  String palletNoInput = '';
  String weightInput = '';
  String unitInput = '';
  String bagTypeInput = '';
  String productionDateInput = '';
  String tisiInput = '';
  String labelQtyInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';
  String accessToken = '';
  String username = '';

  late RePrintCreate resultReprintCreate = RePrintCreate();

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
        matDescVisible = false;
        lotVisible = false;
        palletNoVisible = false;
        weightVisible = false;
        unitVisible = false;
        bagTypeVisible = false;
        productionDateVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;

        buttonVisible = false;
      });
    } else if (step == 2) {
      matNumberVisible = true;
      matDescVisible = true;
      lotVisible = true;
      palletNoVisible = true;
      weightVisible = true;
      unitVisible = true;
      bagTypeVisible = true;
      productionDateVisible = true;
      tisiVisible = true;
      labelQtyVisible = false;

      buttonVisible = true;
    } else if (step == 3) {
      matNumberVisible = true;
      matDescVisible = true;
      lotVisible = true;
      palletNoVisible = true;
      weightVisible = true;
      unitVisible = true;
      bagTypeVisible = true;
      productionDateVisible = true;
      tisiVisible = true;
      labelQtyVisible = true;

      buttonVisible = true;
    } else if (step == 4) {
      matNumberVisible = true;
      matDescVisible = true;
      lotVisible = true;
      palletNoVisible = true;
      weightVisible = true;
      unitVisible = true;
      bagTypeVisible = true;
      productionDateVisible = true;
      tisiVisible = true;
      labelQtyVisible = true;

      buttonVisible = true;
    }
  }

  void setReadOnly() {
    if (step == 1) {
      setState(() {
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        palletNoReadonly = false;
        weightReadonly = false;
        unitReadonly = false;
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
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        productionDateReadonly = true;
        tisiReadonly = false;
        labelQtyReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    }
    if (step == 3) {
      setState(() {
        matNumberReadonly = true;
        matDescReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        productionDateReadonly = true;
        tisiReadonly = true;
        labelQtyReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    }
    if (step == 4) {
      setState(() {
        matNumberReadonly = true;
        matDescReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
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
        palletNoColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
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
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        productionDateColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        matNumberColor = Color(0xFFEEEEEE);
        matDescColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        productionDateColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFEEEEEE);
        labelQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 4) {
      setState(() {
        matNumberColor = Color(0xFFEEEEEE);
        matDescColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
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
        palletNoController.text = '';
        weightController.text = '';
        unitController.text = '';
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
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        productionDateController.text = productionDateInput;
        tisiController.text = '';
        labelQtyController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        matNumberController.text = matNumberInput;
        matDescController.text = matDescInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        productionDateController.text = productionDateInput;
        tisiController.text = tisiInput;
        labelQtyController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        matNumberController.text = matNumberInput;
        matDescController.text = matDescInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
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
    } else if (step == 3) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[2]));
    } else if (step == 4) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[3]));
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
      matNumberController.text = barcodeScanRes;
      await matnoValidateCheck();
    }
    return;
  }

  Future<void> matnoValidateCheck() async {
    await showProgressLoading(false);
    setState(() {
      matNumberController.text =
          'Moplen HP400H|610009.0025|60134684|21|1000|kgs|2024-09-10T06:48:07.978Z||';
    });
    var split = matNumberController.text.split('|');
    print(split.length);
    if (split.length < 7 ) {
      setState(() {
        matNumberController.text = '';
      });
      await showProgressLoading(true);
      showErrorDialog('Matno. Invalid');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
    }

    if (split.length == 7) {
      setState(() {
        matDescInput = split[0];
        matNumberInput = split[1];
        lotInput = split[2];
        palletNoInput = split[3];
        weightInput = split[4];
        unitInput = split[5];
        bagTypeInput = 'LB';
        productionDateInput = split[6];
        tisiInput = '';
        labelQtyInput = '';
        step = 3;
      });
    } else if (split.length > 7 ) {
      setState(() {
        matDescInput = split[0];
        matNumberInput = split[1];
        lotInput = split[2];
        palletNoInput = split[3];
        weightInput = split[4];
        unitInput = split[5];
        bagTypeInput = 'JB';
        productionDateInput = split[6];
        tisiInput = '';
        labelQtyInput = '';
        step++;
      });
    }

    await showProgressLoading(true);
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> tisiValidateCheck() async {
    await showProgressLoading(false);
    setState(() {
      tisiInput = tisiController.text;
      step++;
    });
    await showProgressLoading(true);
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> labelQtyValidateCheck() async {
    await showProgressLoading(false);
    setState(() {
      labelQtyInput = labelQtyController.text;
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
    setState(() {
      submitEnabled = false;
    });
    await showProgressLoading(false);

    //call Update
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;
      username = prefs.getString('username')!;

      if (bagTypeInput == 'LB') {
        setState(() {
          resultReprintCreate.matDesc = matDescInput;
          resultReprintCreate.matNo = matNumberInput;
          resultReprintCreate.batch = lotInput;
          resultReprintCreate.palletNo = palletNoInput;
          resultReprintCreate.weight = int.parse(weightInput);
          resultReprintCreate.unit = unitInput;
          resultReprintCreate.bagType = bagTypeInput;
          resultReprintCreate.tisi = tisiInput;
          resultReprintCreate.labelQty = int.parse(labelQtyInput);
          resultReprintCreate.productionDate = null;
          resultReprintCreate.user = username;
        });
      } else {
        setState(() {
          resultReprintCreate.matDesc = matDescInput;
          resultReprintCreate.matNo = matNumberInput;
          resultReprintCreate.batch = lotInput;
          resultReprintCreate.palletNo = palletNoInput;
          resultReprintCreate.weight = int.parse(weightInput);
          resultReprintCreate.unit = unitInput;
          resultReprintCreate.bagType = bagTypeInput;
          resultReprintCreate.tisi = tisiInput;
          resultReprintCreate.labelQty = int.parse(labelQtyInput);
          resultReprintCreate.productionDate = productionDateInput;
          resultReprintCreate.user = username;
        });
      }

      var url = Uri.parse('http://' + configs + '/api/Barcode/ReprintLabel');

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      final encoding = Encoding.getByName('utf-8');
      var jsonBody = jsonEncode(resultReprintCreate);

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        setState(() {
          step = 1;
        });
        await showProgressLoading(true);
        showSuccessDialog('Post Successful!');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
      } else {
        await showProgressLoading(true);
        showErrorDialog('Error ReprintLabel');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } catch (e) {
      await showProgressLoading(true);
      showErrorDialog('Error occured while ReprintLabel');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }
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
                          matnoValidateCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matNumberColor,
                          filled: true,
                          hintText: 'Enter MatNo.',
                          labelText: 'Mat No',
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
                      visible: matDescVisible,
                      child: TextFormField(
                        readOnly: matDescReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matDescColor,
                          filled: true,
                          hintText: 'Enter Mat Desc.',
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
                      visible: lotVisible,
                      child: TextFormField(
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
                      visible: palletNoVisible,
                      child: TextFormField(
                        readOnly: palletNoReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: palletNoColor,
                          filled: true,
                          hintText: 'Enter palletNo.',
                          labelText: 'palletNo',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: palletNoController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: weightVisible,
                      child: TextFormField(
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
                      visible: unitVisible,
                      child: TextFormField(
                        readOnly: unitReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: unitColor,
                          filled: true,
                          hintText: 'Enter Unit',
                          labelText: 'Unit',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: unitController,
                      ))),
              SizedBox(
                height: 14,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: bagTypeVisible,
                      child: TextFormField(
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
                      visible: productionDateVisible,
                      child: TextFormField(
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
                      visible: tisiVisible,
                      child: TextFormField(
                        focusNode: focusNodes[1],
                        readOnly: tisiReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          tisiValidateCheck();
                        },
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
                      visible: labelQtyVisible,
                      child: TextFormField(
                        focusNode: focusNodes[2],
                        readOnly: labelQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          labelQtyValidateCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: labelQtyColor,
                          filled: true,
                          hintText: 'Enter Qty',
                          labelText: 'Qty',
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
                            focusNode: focusNodes[3],
                            color: Colors.green,
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

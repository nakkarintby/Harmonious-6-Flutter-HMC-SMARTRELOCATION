import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/createBarCode.dart';
import 'package:test/class/resvalidatepalletitem.dart';
import 'package:test/screens/history.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  TextEditingController palletnumberController = TextEditingController();
  TextEditingController packingQtyController = TextEditingController();
  TextEditingController labelQtyController = TextEditingController();
  TextEditingController mogController = TextEditingController();

  bool matNumberVisible = false;
  bool detailVisible = false;
  bool mogVisible = false;
  bool buttonVisible = false;

  bool matNumberReadonly = false;
  bool matDescReadonly = false;
  bool lotReadonly = false;
  bool palletnumberReadonly = false;
  bool packingQtyReadonly = false;
  bool labelQtyReadonly = false;
  bool mogReadonly = false;

  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletnumberColor = Color(0xFFFFFFFF);
  Color packingQtyColor = Color(0xFFFFFFFF);
  Color labelQtyColor = Color(0xFFFFFFFF);
  Color mogColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool submitEnabled = false;

  String matNumberInput = '';
  String matDescInput = '';
  String lotInput = '';
  String palletnumberInput = '';
  String packingQtyInput = '';
  String labelQtyInput = '';
  String mogInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(2, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';
  String accessToken = '';
  String username = '';
  bool haveMOG = false;

  var desc = '';
  var batch = '';
  var palletno = '';
  var weight = '';
  var bagType = '';
  var unit = '';
  var productionDate = '';

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    getSharedPrefs();
    setState(() {
      step = 1;
      haveMOG = true;
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
        matNumberVisible = true;
        detailVisible = false;
        mogVisible = false;
        buttonVisible = false;
      });
    } else if (step == 2) {
      if (!haveMOG) {
        setState(() {
          matNumberVisible = false;
          detailVisible = true;
          mogVisible = false;
          buttonVisible = true;
        });
      } else {
        setState(() {
          matNumberVisible = false;
          detailVisible = true;
          mogVisible = true;
          buttonVisible = true;
        });
      }
    }
  }

  void setReadOnly() {
    if (step == 1) {
      setState(() {
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        packingQtyReadonly = false;
        labelQtyReadonly = false;
        mogReadonly = false;

        backEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      if (!haveMOG) {
        setState(() {
          matNumberReadonly = true;
          matDescReadonly = true;
          lotReadonly = true;
          palletnumberReadonly = true;
          packingQtyReadonly = true;
          labelQtyReadonly = false;
          mogReadonly = false;

          backEnabled = true;
          submitEnabled = true;
        });
      } else {
        setState(() {
          matNumberReadonly = true;
          matDescReadonly = true;
          lotReadonly = true;
          palletnumberReadonly = true;
          packingQtyReadonly = true;
          labelQtyReadonly = false;
          mogReadonly = false;

          backEnabled = true;
          submitEnabled = true;
        });
      }
    }
  }

  void setColor() {
    if (step == 1) {
      setState(() {
        matNumberColor = Color(0xFFFFFFFF);
        matDescColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        packingQtyColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        mogColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      if (!haveMOG) {
        setState(() {
          matNumberColor = Color(0xFFEEEEEE);
          matDescColor = Color(0xFFEEEEEE);
          lotColor = Color(0xFFEEEEEE);
          palletnumberColor = Color(0xFFEEEEEE);
          packingQtyColor = Color(0xFFEEEEEE);
          labelQtyColor = Color(0xFFFFFFFF);
          mogColor = Color(0xFFFFFFFF);
        });
      } else {
        setState(() {
          matNumberColor = Color(0xFFEEEEEE);
          matDescColor = Color(0xFFEEEEEE);
          lotColor = Color(0xFFEEEEEE);
          palletnumberColor = Color(0xFFEEEEEE);
          packingQtyColor = Color(0xFFEEEEEE);
          labelQtyColor = Color(0xFFFFFFFF);
          mogColor = Color(0xFFFFFFFF);
        });
      }
    }
  }

  void setText() {
    if (step == 1) {
      setState(() {
        matNumberController.text = '';
        matDescController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
        packingQtyController.text = '';
        labelQtyController.text = '';
        mogController.text = '';
      });
    } else if (step == 2) {
      if (!haveMOG) {
        setState(() {
          matNumberController.text = matNumberInput;
          matDescController.text = matDescInput;
          lotController.text = lotInput;
          palletnumberController.text = palletnumberInput;
          packingQtyController.text = packingQtyInput;
          labelQtyController.text = '';
          mogController.text = '';
        });
      } else {
        setState(() {
          matNumberController.text = matNumberInput;
          matDescController.text = matDescInput;
          lotController.text = lotInput;
          palletnumberController.text = palletnumberInput;
          packingQtyController.text = packingQtyInput;
          labelQtyController.text = '';
          mogController.text = '';
        });
      }
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
    setState(() {
      matNumberController.text =
          'Moplen HP400K|60112405|272|750|KG|2017-08-08|';
    });

    var split = matNumberController.text.split('|');

    //setBagType
    if (split.length == 6) {
      setState(() {
        bagType = 'LB';
        haveMOG = false;
        productionDate = '';
        mogController.text = '';
        labelQtyController.text = '';
      });
    } else if (split.length == 7) {
      setState(() {
        bagType = 'JB';
        haveMOG = true;
        productionDate = split[5];
        mogController.text = '';
        labelQtyController.text = '';
      });
    }

    setState(() {
      desc = split[0];
      batch = split[1];
      palletno = split[2];
      weight = split[3];
      unit = split[4];
    });

    setState(() {
      step++;
      matNumberInput = matNumberController.text;
      matDescInput = desc;
      lotInput = batch;
      palletnumberInput = palletno;
      packingQtyInput = weight;
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> submitStep() async {
    if (haveMOG) {
      if (labelQtyController.text == '' || mogController.text == '') {
        showErrorDialog('Please Enter Data');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } else {
      if (labelQtyController.text == '') {
        showErrorDialog('Please Enter Data');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    }

    //call GenerateBarcode API
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;
      username = prefs.getString('username')!;

      CreateBarCode createBC = new CreateBarCode();
      setState(() {
        labelQtyInput = labelQtyController.text;
        mogInput = mogController.text;
        createBC.bagType = '12'; //if user bagtype JB or LB post not successful
        createBC.matNo = '1';
        createBC.matDesc = desc;
        createBC.batch = batch;
        createBC.palletNo = palletnumberInput;
        createBC.weight = int.parse(weight);
        createBC.unit = unit;
        createBC.productionDate = productionDate;
        createBC.tisi = mogInput;
        createBC.labelQty = int.parse(labelQtyInput);
        createBC.user = username;
      });

      if (productionDate == '') {
        setState(() {
          createBC.productionDate = null;
        });
      }

      var url =
          Uri.parse('http://' + configs + '/API/api/Barcode/GenerateBarcode');

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      final encoding = Encoding.getByName('utf-8');
      var jsonBody = jsonEncode(createBC);

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        showSuccessDialog('Post Successful!');
        setState(() {
          step = 1;
        });
      } else {
        showErrorDialog('Error GenerateBarcode');
      }
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
    } catch (e) {
      showErrorDialog('Error occured while GenerateBarcode');
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
                height: 28,
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
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: matNumberController,
                      ))),
              SizedBox(
                height: 18,
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
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: matDescController,
                      ))),
              SizedBox(
                height: 18,
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
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: lotController,
                      ))),
              SizedBox(
                height: 18,
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
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: palletnumberController,
                      ))),
              SizedBox(
                height: 18,
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
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: packingQtyController,
                      ))),
              SizedBox(
                height: 18,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: mogVisible,
                      child: TextFormField(
                        //focusNode: focusNodes[0],
                        readOnly: mogReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: mogColor,
                          filled: true,
                          hintText: 'Enter MOG',
                          labelText: 'MOG',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: mogController,
                      ))),
              SizedBox(
                height: 18,
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
                          hintText: 'Enter Label Qty',
                          labelText: 'Label Qty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(16), //
                        ),
                        controller: labelQtyController,
                      ))),
              SizedBox(
                height: 18,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 8,
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
                                ? () async {
                                    await submitStep();
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/deliveryOrderDOValidate.dart';
import 'package:test/class/selectLTLoaded.dart';
import 'package:test/class/updateSelectLTLoaded.dart';
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

class Cancle extends StatefulWidget {
  const Cancle({Key? key}) : super(key: key);

  @override
  _CancleState createState() => _CancleState();
}

class _CancleState extends State<Cancle> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController matNumberController = TextEditingController();
  TextEditingController matDescLabelController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController palletnumberController = TextEditingController();

  bool documentNumberVisible = false;
  bool matNumberVisible = false;
  bool detailVisible = false;
  bool buttonVisible = false;

  bool documentNumberReadonly = false;
  bool matNumberReadonly = false;
  bool matDescLabelReadonly = false;
  bool lotReadonly = false;
  bool palletnumberReadonly = false;

  Color documentNumberColor = Color(0xFFFFFFFF);
  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescLabelColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletnumberColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool submitEnabled = false;

  String documentNumberInput = '';
  String plandate = '';
  String matNumberInput = '';
  String matDescLabelInput = '';
  String lotInput = '';
  String palletnumberInput = '';
  int quantity = 0;

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';
  String accessToken = '';
  String username = '';

  late DeliveryOrderDOValidate resultDeliveryOrderDOValidate =
      DeliveryOrderDOValidate();

  late SelectLTLoaded resultSelectLTLoaded = SelectLTLoaded();

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
        matDescLabelReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;

        backEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = false;
        matDescLabelReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 3) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = true;
        matDescLabelReadonly = true;
        lotReadonly = true;
        palletnumberReadonly = true;

        backEnabled = true;
        submitEnabled = true;
      });
    }
  }

  void setColor() {
    if (step == 1) {
      setState(() {
        documentNumberColor = Color(0xFFFFFFFF);
        matNumberColor = Color(0xFFFFFFFF);
        matDescLabelColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFFFFFFF);
        matDescLabelColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        matDescLabelColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletnumberColor = Color(0xFFEEEEEE);
      });
    }
  }

  void setText() {
    if (step == 1) {
      setState(() {
        documentNumberController.text = '';
        matNumberController.text = '';
        matDescLabelController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
      });
    } else if (step == 2) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = '';
        matDescLabelController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = matNumberInput;
        matDescLabelController.text = matDescLabelInput;
        lotController.text = lotInput;
        palletnumberController.text = palletnumberInput;
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
    await showProgressLoading(false);

    var split = documentNumberController.text.split('|');

    if (split.length != 2) {
      setState(() {
        documentNumberController.text = '';
        documentNumberInput = '';
        plandate = '';
      });
      await showProgressLoading(true);
      showErrorDialog('Document Number Format Invalid');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }

    setState(() {
      documentNumberInput = split[0];
      plandate = split[1];
    });

    //api/DeliveryOrder/DOValidate
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;

      var url = Uri.parse('http://' +
          configs +
          '/api/DeliveryOrder/DOValidate?dono=' +
          documentNumberInput +
          '&plandate=' +
          plandate);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          resultDeliveryOrderDOValidate =
              DeliveryOrderDOValidate.fromJson(data);
        });

        //check validate result api
        if (resultDeliveryOrderDOValidate.result! == false) {
          setState(() {
            documentNumberController.text = '';
            documentNumberInput = '';
            plandate = '';
          });
          await showProgressLoading(true);
          showErrorDialog(resultDeliveryOrderDOValidate.message!);
          setVisible();
          setReadOnly();
          setColor();
          setText();
          setFocus();
          return;
        }

        setState(() {
          step++;
        });
        await showProgressLoading(true);
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
      } else {
        setState(() {
          documentNumberController.text = '';
          documentNumberInput = '';
          plandate = '';
        });
        await showProgressLoading(true);
        showErrorDialog('Error DOValidate');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } catch (e) {
      setState(() {
        documentNumberController.text = '';
        documentNumberInput = '';
        plandate = '';
      });
      await showProgressLoading(true);
      showErrorDialog('Error occured while DOValidate');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }
  }

  Future<void> matNumberCheck() async {
    await showProgressLoading(false);

    var split = matNumberController.text.split('|');

    if (split.length != 6 && split.length != 7) {
      await showProgressLoading(true);
      setState(() {
        matNumberController.text = '';
        matNumberInput = '';
      });
      showErrorDialog('MatNumber Format Invalid');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }

    setState(() {
      matDescLabelInput = split[0];
      matNumberInput = resultDeliveryOrderDOValidate.deliveryOrder![0].matno!;
      lotInput = split[1];
      palletnumberInput = split[2];
      quantity = int.parse(split[3]);
    });

    //validate mat no
    var checkResultDOValidate = resultDeliveryOrderDOValidate.deliveryOrder!
        .firstWhere(
            (e) => e.matDescLabel == matDescLabelInput && e.batch == lotInput,
            orElse: () => DeliveryOrder());

    if (checkResultDOValidate.deliveryOrderId == null) {
      await showProgressLoading(true);
      setState(() {
        matNumberController.text = '';
        matNumberInput = '';
      });
      showErrorDialog('MatNumber Invalid');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }

    //call api LoadTracking/SelectLTLoaded
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;

      var url = Uri.parse('http://' +
          configs +
          '/api/LoadTracking/SelectLTLoaded?matno=' +
          matNumberInput +
          '&batch=' +
          lotInput +
          '&palletno=' +
          palletnumberInput);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 204) {
        setState(() {
          matNumberController.text = '';
          matNumberInput = '';
        });
        await showProgressLoading(true);
        showErrorDialog('ไม่พบสินค้าพาเลทนี้ในระบบ');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      } else if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          resultSelectLTLoaded = SelectLTLoaded.fromJson(data);
        });

        if (resultSelectLTLoaded.quantity != quantity) {
          setState(() {
            matNumberController.text = '';
            matNumberInput = '';
          });
          await showProgressLoading(true);
          showErrorDialog('น้ำหนักพาเลทสินค้าไม่ถูกต้อง');
          setVisible();
          setReadOnly();
          setColor();
          setText();
          setFocus();
          return;
        }

        setState(() {
          step++;
        });

        await showProgressLoading(true);
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
      } else {
        setState(() {
          matNumberController.text = '';
          matNumberInput = '';
        });
        await showProgressLoading(true);
        showErrorDialog('Error SelectLTLoaded');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } catch (e) {
      setState(() {
        matNumberController.text = '';
        matNumberInput = '';
      });
      await showProgressLoading(true);
      showErrorDialog('Error occured while SelectLTLoaded');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }
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

      setState(() {
        resultSelectLTLoaded.lastUpdatedBy = username;
        resultSelectLTLoaded.isDeleted = true;
      });

      var url = Uri.parse('http://' + configs + '/api/LoadTracking/Update');

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      final encoding = Encoding.getByName('utf-8');
      var jsonBody = jsonEncode(resultSelectLTLoaded);

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        setState(() {
          step = 2;
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
        showErrorDialog('Error CreateLoadTrackingFromHH');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } catch (e) {
      await showProgressLoading(true);
      showErrorDialog('Error occured while CreateLoadTrackingFromHH');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }
  }

  Future<void> setHistoryHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('doGI', documentNumberInput);
    await prefs.setString('lotGI', lotInput);
  }

  Future<void> setDetailHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('doGI', documentNumberInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Cancel',
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
                        readOnly: matDescLabelReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matDescLabelColor,
                          filled: true,
                          hintText: 'Enter Mat Desc',
                          labelText: 'Mat Desc',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: matDescLabelController,
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
                            focusNode: focusNodes[2],
                            color: step == 3 ? Colors.green : Colors.blue,
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

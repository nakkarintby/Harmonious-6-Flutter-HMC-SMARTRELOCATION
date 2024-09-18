import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/deliveryOrderDOValidate.dart';
import 'package:test/class/selectChkLoadedFull.dart';
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
import 'package:test/screens/takePhoto.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController matNumberController = TextEditingController();
  TextEditingController matDescController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController palletnumberController = TextEditingController();
  TextEditingController pickingQtyController = TextEditingController();
  TextEditingController remainQtyController = TextEditingController();

  bool documentNumberVisible = false;
  bool matNumberVisible = false;
  bool detailVisible = false;
  bool buttonVisible = false;

  bool documentNumberReadonly = false;
  bool matNumberReadonly = false;
  bool matDescReadonly = false;
  bool lotReadonly = false;
  bool palletnumberReadonly = false;
  bool pickingQtyReadonly = false;
  bool remainQtyReadonly = false;

  Color documentNumberColor = Color(0xFFFFFFFF);
  Color matNumberColor = Color(0xFFFFFFFF);
  Color matDescColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletnumberColor = Color(0xFFFFFFFF);
  Color pickingQtyColor = Color(0xFFFFFFFF);
  Color remainQtyColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool takePhotoEnabled = false;
  bool submitEnabled = false;

  String documentNumberInput = '';
  String plandate = '';
  String matNumberInput = '';
  String matDescLabelInput = '';
  String lotInput = '';
  String palletnumberInput = '';
  String pickingQtyInput = '';
  String remainQtyInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';
  String accessToken = '';
  String username = '';

  late DeliveryOrderDOValidate resultDeliveryOrderDOValidate =
      DeliveryOrderDOValidate();

  late SelectChkLoadedFull resultSelectChkLoadedFull = SelectChkLoadedFull();

  var qtyLoaded = 0;
  var orderQty = 0;
  var remainQty = 0;
  var pickingQty = 0;
  String sloc = '';
  int sequence = 0;
  DeliveryOrder checkResultDOValidate = DeliveryOrder();

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
        matDescReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        pickingQtyReadonly = false;
        remainQtyReadonly = false;

        backEnabled = false;
        takePhotoEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = false;
        matDescReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        pickingQtyReadonly = false;
        remainQtyReadonly = false;

        backEnabled = true;
        takePhotoEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 3) {
      setState(() {
        documentNumberReadonly = true;
        matNumberReadonly = true;
        matDescReadonly = true;
        lotReadonly = true;
        palletnumberReadonly = true;
        pickingQtyReadonly = true;
        remainQtyReadonly = true;

        backEnabled = true;
        takePhotoEnabled = true;
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
        pickingQtyColor = Color(0xFFFFFFFF);
        remainQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFFFFFFF);
        matDescColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        pickingQtyColor = Color(0xFFFFFFFF);
        remainQtyColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        documentNumberColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        matDescColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletnumberColor = Color(0xFFEEEEEE);
        pickingQtyColor = Color(0xFFEEEEEE);
        remainQtyColor = Color(0xFFEEEEEE);
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
        pickingQtyController.text = '';
        remainQtyController.text = '';
      });
    } else if (step == 2) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = '';
        matDescController.text = '';
        lotController.text = '';
        palletnumberController.text = '';
        pickingQtyController.text = '';
        remainQtyController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        documentNumberController.text = documentNumberInput;
        matNumberController.text = matNumberInput;
        matDescController.text = matDescLabelInput;
        lotController.text = lotInput;
        palletnumberController.text = palletnumberInput;
        pickingQtyController.text = pickingQtyInput;
        remainQtyController.text = remainQtyInput;
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
          '/api/Transfer/DOValidate?dono=' +
          documentNumberInput);

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

    setState(() {
      matDescLabelInput = split[0];
      matNumberInput = split[1];
      lotInput = split[2];
      palletnumberInput = split[3];
      pickingQtyInput = split[4];
      remainQtyInput = '';
    });

    //validate mat no
    var checkResultDOValidate = resultDeliveryOrderDOValidate.deliveryOrder!
        .firstWhere(
            (e) =>
                e.matDescLabel == matDescLabelInput &&
                e.matno == matNumberInput &&
                e.batch == lotInput,
            orElse: () => DeliveryOrder());

    if (checkResultDOValidate.deliveryOrderId == null) {
      setState(() {
        matNumberController.text = '';
        matNumberInput = '';
      });
      await showProgressLoading(true);
      showErrorDialog('MatNumber Invalid');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    } else {
      setState(() {
        orderQty = checkResultDOValidate.quantity!;
        sloc = checkResultDOValidate.sloc!;
        sequence = checkResultDOValidate.sequence!;
      });
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
          '/api/LoadTracking/SelectLTLoaded/' +
          matNumberInput +
          '/' +
          lotInput +
          '/' +
          palletnumberInput);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 204) {
        //next step
      } else if (response.statusCode == 200) {
        setState(() {
          matNumberController.text = '';
          matNumberInput = '';
        });
        await showProgressLoading(true);
        showErrorDialog('สินค้าพาเลทนี้ถูกสแกนแล้ว');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
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

    //call api LoadTracking/SelectLTQTYLoaded
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;

      var url = Uri.parse('http://' +
          configs +
          '/api/LoadTracking/SelectLTQTYLoaded/' +
          documentNumberInput +
          '/' +
          plandate +
          '/' +
          matNumberInput +
          '/' +
          lotInput);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          qtyLoaded = data;
          remainQty = orderQty - qtyLoaded;
          remainQtyInput = remainQty.toString();
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
        showErrorDialog('Error SelectLTQTYLoaded');
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
      showErrorDialog('Error occured while SelectLTQTYLoaded');
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

    //call api LoadTracking/SelectChkLoadedFull
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;

      var url = Uri.parse('http://' +
          configs +
          '/api/LoadTracking/SelectChkLoadedFull/' +
          documentNumberInput +
          '/' +
          plandate);

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          resultSelectChkLoadedFull = SelectChkLoadedFull.fromJson(data);
        });

        int tmppicking = int.parse(pickingQtyInput);

        //validate qty
        if (tmppicking > remainQty) {
          setState(() {
            step--;
          });
          await showProgressLoading(true);
          showErrorDialog('น้ำหนักเกิน Order');
          setVisible();
          setReadOnly();
          setColor();
          setText();
          setFocus();
          return;
        }

        //next step
      } else if (response.statusCode == 204) {
        //first scan pallet will not find
      } else {
        await showProgressLoading(true);
        showErrorDialog('Error SelectChkLoadedFull');
        setVisible();
        setReadOnly();
        setColor();
        setText();
        setFocus();
        return;
      }
    } catch (e) {
      await showProgressLoading(true);
      showErrorDialog('Error occured while SelectChkLoadedFull');
      setVisible();
      setReadOnly();
      setColor();
      setText();
      setFocus();
      return;
    }

    //call CreateLoadTrackingFromHH
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      accessToken = prefs.getString('token')!;
      username = prefs.getString('username')!;

      CreateLoadingTracking createLT = new CreateLoadingTracking();
      setState(() {
        createLT.dono = documentNumberInput;
        createLT.planDate = plandate;
        createLT.isDeleted = false;
        createLT.matno = matNumberInput;
        createLT.matDescLabel = matDescLabelInput;
        createLT.batch = lotInput;
        createLT.sloc = resultDeliveryOrderDOValidate.deliveryOrder![0].sloc!;
        createLT.palletno = palletnumberInput;
        createLT.quantity = int.parse(pickingQtyInput);
        createLT.createdBy = username;
      });

      var url = Uri.parse(
          'http://' + configs + '/api/LoadTracking/CreateLoadTrackingFromHH');

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      final encoding = Encoding.getByName('utf-8');
      var jsonBody = jsonEncode(createLT);

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

  Future<void> setTakePhotoHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('donoTakePhoto', documentNumberInput);
    await prefs.setString('plandateTakePhoto', plandate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Transfer',
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
                        readOnly: pickingQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: pickingQtyColor,
                          filled: true,
                          hintText: 'Enter Order Qty',
                          labelText: 'Picking Qty',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14), //
                        ),
                        controller: pickingQtyController,
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
              Visibility(
                  visible: buttonVisible,
                  child: new Center(
                    child: new ButtonBar(
                      mainAxisSize: MainAxisSize
                          .min, // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        Container(
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
                          child: new RaisedButton(
                            color: Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.add_a_photo_outlined)
                              ],
                            ),
                            onPressed: takePhotoEnabled
                                ? () async {
                                    await setTakePhotoHeader();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => takePhoto()));
                                  }
                                : null,
                          ),
                        ),
                        Container(
                          child: new RaisedButton(
                            focusNode: focusNodes[2],
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

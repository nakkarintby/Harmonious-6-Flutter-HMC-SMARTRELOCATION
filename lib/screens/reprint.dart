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
  TextEditingController matDescController = TextEditingController();
  TextEditingController matNumberController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController palletNoController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController bagTypeController = TextEditingController();
  TextEditingController tisiController = TextEditingController();
  TextEditingController labelQtyController = TextEditingController();
  TextEditingController productionDateController = TextEditingController();

  bool matDescVisible = false;
  bool matNumberVisible = false;
  bool lotVisible = false;
  bool palletNoVisible = false;
  bool weightVisible = false;
  bool unitVisible = false;
  bool bagTypeVisible = false;
  bool tisiVisible = false;
  bool labelQtyVisible = false;
  bool productionDateVisible = false;

  bool buttonVisible = false;

  bool matDescReadonly = false;
  bool matNumberReadonly = false;
  bool lotReadonly = false;
  bool palletNoReadonly = false;
  bool weightReadonly = false;
  bool unitReadonly = false;
  bool bagTypeReadonly = false;
  bool tisiReadonly = false;
  bool labelQtyReadonly = false;
  bool productionDateReadonly = false;

  Color matDescColor = Color(0xFFFFFFFF);
  Color matNumberColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletNoColor = Color(0xFFFFFFFF);
  Color weightColor = Color(0xFFFFFFFF);
  Color unitColor = Color(0xFFFFFFFF);
  Color bagTypeColor = Color(0xFFFFFFFF);
  Color tisiColor = Color(0xFFFFFFFF);
  Color labelQtyColor = Color(0xFFFFFFFF);
  Color productionDateColor = Color(0xFFFFFFFF);

  bool backEnabled = false;
  bool submitEnabled = false;

  String matDescInput = '';
  String matNumberInput = '';
  String lotInput = '';
  String palletNoInput = '';
  String weightInput = '';
  String unitInput = '';
  String bagTypeInput = '';
  String tisiInput = '';
  String labelQtyInput = '';
  String productionDateInput = '';

  int step = 1;
  late List<FocusNode> focusNodes = List.generate(11, (index) => FocusNode());
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
        matDescVisible = true;
        matNumberVisible = false;
        lotVisible = false;
        palletNoVisible = false;
        weightVisible = false;
        unitVisible = false;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = false;
      });
    } else if (step == 2) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = false;
        palletNoVisible = false;
        weightVisible = false;
        unitVisible = false;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 3) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = false;
        weightVisible = false;
        unitVisible = false;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 4) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = false;
        unitVisible = false;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 5) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = false;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 6) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = false;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 7) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = true;
        tisiVisible = false;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 8) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = true;
        tisiVisible = true;
        labelQtyVisible = false;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 9) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = true;
        tisiVisible = true;
        labelQtyVisible = true;
        productionDateVisible = false;

        buttonVisible = true;
      });
    } else if (step == 10) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = true;
        tisiVisible = true;
        labelQtyVisible = true;
        productionDateVisible = true;

        buttonVisible = true;
      });
    } else if (step == 11) {
      setState(() {
        matDescVisible = true;
        matNumberVisible = true;
        lotVisible = true;
        palletNoVisible = true;
        weightVisible = true;
        unitVisible = true;
        bagTypeVisible = true;
        tisiVisible = true;
        labelQtyVisible = true;
        productionDateVisible = true;

        buttonVisible = true;
      });
    }
  }

  void setReadOnly() {
    if (step == 1) {
      setState(() {
        matDescReadonly = false;
        matNumberReadonly = false;
        lotReadonly = false;
        palletNoReadonly = false;
        weightReadonly = false;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = false;
        submitEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = false;
        lotReadonly = false;
        palletNoReadonly = false;
        weightReadonly = false;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 3) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = false;
        palletNoReadonly = false;
        weightReadonly = false;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 4) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = false;
        weightReadonly = false;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 5) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = false;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 6) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = false;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 7) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = false;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 8) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        tisiReadonly = false;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 9) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        tisiReadonly = true;
        labelQtyReadonly = false;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 10) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        tisiReadonly = true;
        labelQtyReadonly = true;
        productionDateReadonly = false;

        backEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 11) {
      setState(() {
        matDescReadonly = true;
        matNumberReadonly = true;
        lotReadonly = true;
        palletNoReadonly = true;
        weightReadonly = true;
        unitReadonly = true;
        bagTypeReadonly = true;
        tisiReadonly = true;
        labelQtyReadonly = true;
        productionDateReadonly = true;

        backEnabled = true;
        submitEnabled = true;
      });
    }
  }

  void setColor() {
    if (step == 1) {
      setState(() {
        matDescColor = Color(0xFFFFFFFF);
        matNumberColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletNoColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletNoColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFFFFFFF);
        palletNoColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 4) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFFFFFFF);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 5) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFFFFFFF);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 6) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFFFFFFF);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 7) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFFFFFFF);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 8) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFFFFFFF);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 9) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFEEEEEE);
        labelQtyColor = Color(0xFFFFFFFF);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 10) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFEEEEEE);
        labelQtyColor = Color(0xFFEEEEEE);
        productionDateColor = Color(0xFFFFFFFF);
      });
    } else if (step == 11) {
      setState(() {
        matDescColor = Color(0xFFEEEEEE);
        matNumberColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletNoColor = Color(0xFFEEEEEE);
        weightColor = Color(0xFFEEEEEE);
        unitColor = Color(0xFFEEEEEE);
        bagTypeColor = Color(0xFFEEEEEE);
        tisiColor = Color(0xFFEEEEEE);
        labelQtyColor = Color(0xFFEEEEEE);
        productionDateColor = Color(0xFFEEEEEE);
      });
    }
  }

  void setText() {
    if (step == 1) {
      setState(() {
        matDescController.text = '';
        matNumberController.text = '';
        lotController.text = '';
        palletNoController.text = '';
        weightController.text = '';
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 2) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = '';
        lotController.text = '';
        palletNoController.text = '';
        weightController.text = '';
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 3) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = '';
        palletNoController.text = '';
        weightController.text = '';
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 4) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = '';
        weightController.text = '';
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 5) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = '';
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 6) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = '';
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 7) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = '';
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 8) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        tisiController.text = '';
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 9) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        tisiController.text = tisiInput;
        labelQtyController.text = '';
        productionDateController.text = '';
      });
    } else if (step == 10) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        tisiController.text = tisiInput;
        labelQtyController.text = labelQtyInput;
        productionDateController.text = '';
      });
    } else if (step == 11) {
      setState(() {
        matDescController.text = matDescInput;
        matNumberController.text = matNumberInput;
        lotController.text = lotInput;
        palletNoController.text = palletNoInput;
        weightController.text = weightInput;
        unitController.text = unitInput;
        bagTypeController.text = bagTypeInput;
        tisiController.text = tisiInput;
        labelQtyController.text = labelQtyInput;
        productionDateController.text = productionDateInput;
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
    } else if (step == 5) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[4]));
    } else if (step == 6) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[5]));
    } else if (step == 7) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[6]));
    } else if (step == 8) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[7]));
    } else if (step == 9) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[8]));
    } else if (step == 10) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[9]));
    } else if (step == 11) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[10]));
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
    if (step == 11) {
      return;
    }
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    await validateCheck(barcodeScanRes);
    return;
  }

  Future<void> validateCheck(String value) async {
    await showProgressLoading(false);
    switch (step) {
      case 1:
        setState(() {
          matDescInput = value;
          step++;
        });
        break;
      case 2:
        setState(() {
          matNumberInput = value;
          step++;
        });
        break;
      case 3:
        setState(() {
          lotInput = value;
          step++;
        });
        break;
      case 4:
        setState(() {
          palletNoInput = value;
          step++;
        });
        break;
      case 5:
        setState(() {
          weightInput = value;
          step++;
        });
        break;
      case 6:
        setState(() {
          unitInput = value;
          step++;
        });
        break;
      case 7:
        setState(() {
          bagTypeInput = value;
          step++;
        });
        break;
      case 8:
        setState(() {
          tisiInput = value;
          step++;
        });
        break;
      case 9:
        setState(() {
          labelQtyInput = value;
          step++;
        });
        break;
      case 10:
        setState(() {
          productionDateInput = value;
          step++;
        });
        break;
      default:
        showErrorDialog('Error Validate');
    }

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
                      visible: matDescVisible,
                      child: TextFormField(
                        focusNode: focusNodes[0],
                        readOnly: matDescReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(matDescController.text);
                        },
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
                      visible: matNumberVisible,
                      child: TextFormField(
                        focusNode: focusNodes[1],
                        readOnly: matNumberReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(matNumberController.text);
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
                      visible: lotVisible,
                      child: TextFormField(
                        focusNode: focusNodes[2],
                        readOnly: lotReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(lotController.text);
                        },
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
                        focusNode: focusNodes[3],
                        readOnly: palletNoReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(palletNoController.text);
                        },
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
                        focusNode: focusNodes[4],
                        readOnly: weightReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(weightController.text);
                        },
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
                        focusNode: focusNodes[5],
                        readOnly: unitReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(unitController.text);
                        },
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
                        focusNode: focusNodes[6],
                        readOnly: bagTypeReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(bagTypeController.text);
                        },
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
                      visible: tisiVisible,
                      child: TextFormField(
                        focusNode: focusNodes[7],
                        readOnly: tisiReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(tisiController.text);
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
                        focusNode: focusNodes[8],
                        readOnly: labelQtyReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(labelQtyController.text);
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
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: productionDateVisible,
                      child: TextFormField(
                        focusNode: focusNodes[9],
                        readOnly: productionDateReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          validateCheck(productionDateController.text);
                        },
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
                            focusNode: focusNodes[10],
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

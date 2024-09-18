          import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:test/class/createAttachment.dart';
import 'package:test/class/deliveryOrderDOValidate.dart';
import 'package:test/class/listAllHistoryGI.dart';
import 'package:test/class/selectDODetail.dart';
import 'package:test/screens/allHistoryGI.dart';

class takePhoto extends StatefulWidget {
  @override
  _takePhotoState createState() => _takePhotoState();
}

class _takePhotoState extends State<takePhoto> {
  String configs = '';
  String accessToken = "";
  String username = '';
  String dono = '';
  String plandate = '';
  late Timer timer;
  bool backEnabled = true;
  bool takePhotoEnabled = true;
  bool submitEnabled = true;
  final ImagePicker _picker = ImagePicker();
  late File? _image = null;
  String fileInBase64 = '';
  String statusUpload = '';
  String referenceId = '';
  String fileSize = '';
  int step = 0;
  late DeliveryOrderDOValidate resultDeliveryOrderDOValidate =
      DeliveryOrderDOValidate();

  @override
  void initState() {
    super.initState();
    setState(() {
      step = 0;
    });
    setReadOnly();
    setText();
    getSharedPrefs();
  }

  void setReadOnly() {
    if (step == 0) {
      setState(() {
        backEnabled = false;
        takePhotoEnabled = true;
        submitEnabled = false;
      });
    } else if (step == 1) {
      setState(() {
        backEnabled = true;
        takePhotoEnabled = false;
        submitEnabled = true;
      });
    }
  }

  void setText() {
    if (step == 0) {
      setState(() {
        statusUpload = "No image Previews";
      });
    } else if (step == 1) {
      setState(() {
        statusUpload = "";
      });
    }
  }

  void backStep() {
    setState(() {
      step--;
      _image = null;
    });
    setReadOnly();
    setText();
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      configs = prefs.getString('configs');
      accessToken = prefs.getString('token');
      dono = prefs.getString('donoTakePhoto');
      plandate = prefs.getString('plandateTakePhoto');
    });
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

  Future<void> showProgressImageFromCamera() async {
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

    await pr.show();
    timer = Timer(Duration(seconds: 3), () async {
      await pr.hide();
    });
  }

  Future<void> imageFromCamera() async {
    //open camera device
    PickedFile? selectedImage = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 2000,
        maxWidth: 2000);

    //set image from camera
    File? temp;
    if (selectedImage != null) {
      temp = File(selectedImage.path);
      if (selectedImage.path.isNotEmpty) {
        setState(() {
          _image = temp;
          final encodedBytes = _image!.readAsBytesSync();
          fileInBase64 = base64Encode(encodedBytes);
          double tmpSize = fileInBase64.length / (1024);
          fileSize = tmpSize.toString() + 'KB';
        });
      }
    }
    if (_image != null) {
      showProgressImageFromCamera();
      setState(() {
        step++;
      });
      setReadOnly();
      setText();
    }
  }

  Future<void> submitStep() async {
    setState(() {
      submitEnabled = false;
    });

    await showProgressLoading(false);

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
          dono +
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
          await showProgressLoading(true);
          showErrorDialog(resultDeliveryOrderDOValidate.message!);
          setReadOnly();
          setText();
          return;
        }
        //validate mat no
        var checkResultDOValidate = resultDeliveryOrderDOValidate.deliveryOrder!
            .firstWhere((e) => e.recDBType == 'H',
                orElse: () => DeliveryOrder());

        if (checkResultDOValidate.deliveryOrderId == null) {
          await showProgressLoading(true);
          showErrorDialog('DoValidate Error');
          setReadOnly();
          setText();
          return;
        } else {
          setState(() {
            referenceId = checkResultDOValidate.deliveryOrderId!;
          });
        }
      } else {
        await showProgressLoading(true);
        showErrorDialog('Error DOValidate');
        setReadOnly();
        setText();
      }
    } catch (e) {
      await showProgressLoading(true);
      showErrorDialog('Error occured while DOValidate');
      setReadOnly();
      setText();
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        configs = prefs.getString('configs');
        accessToken = prefs.getString('token')!;
        username = prefs.getString('username');
      });

      late CreateAttachment? imageupload = new CreateAttachment();

      setState(() {
        imageupload.referenceId = referenceId;
        imageupload.referenceName = 'SmartRelocation';
        imageupload.value = fileInBase64;
        imageupload.fileName = dono + '.png';
        imageupload.fileSize = fileSize.toString();
        imageupload.userType = 'wareHouse';
        imageupload.isDeleted = false;
        imageupload.createdBy = username;
      });

      var url = Uri.parse('http://' + configs + '/api/Attachment/Create');

      var headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + accessToken
      };

      final encoding = Encoding.getByName('utf-8');
      var jsonBody = jsonEncode(imageupload);
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        setState(() {
          step = 0;
          _image = null;
        });
        await showProgressLoading(true);
        showSuccessDialog('Upload Successful!');
        setReadOnly();
        setText();
      } else {
        await showProgressLoading(true);
        showErrorDialog('Error occured while upload');
        setReadOnly();
        setText();
        return;
      }
    } catch (e) {
      await showProgressLoading(true);
      showErrorDialog('Error occured while upload');
      setReadOnly();
      setText();
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
            'TakePhoto',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              SizedBox(height: 25),
              new Center(
                child: new ButtonBar(
                  mainAxisSize: MainAxisSize
                      .min, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    new RaisedButton(
                      color: Colors.red,
                      child: const Text('Back',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: backEnabled
                          ? () {
                              backStep();
                              /*Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Post Complete')));*/
                            }
                          : null,
                    ),
                    new RaisedButton(
                      color: Colors.blue,
                      child: Column(
                        children: <Widget>[Icon(Icons.add_a_photo_outlined)],
                      ),
                      onPressed: takePhotoEnabled
                          ? () {
                              imageFromCamera();
                            }
                          : null,
                    ),
                    new RaisedButton(
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
                  ],
                ),
              ),
              SizedBox(height: 5),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: _image != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 225,
                            height: 225,
                            child: Image.file(
                              _image!,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(statusUpload),
                        ),
                )
              ]),
            ])));
  }
}

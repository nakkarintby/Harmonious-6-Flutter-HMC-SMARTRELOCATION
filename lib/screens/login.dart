import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/resultlogin.dart';
import 'package:test/class/user.dart';
import 'package:test/screens/main_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static String routeName = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController configsController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String configs = 'selene.hms-cloud.com:8882';
  String version = '1.0';
  String urlDownload = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      version = '1.0';
      configs = 'selene.hms-cloud.com:8882';
    });
    setSharedPrefs();
  }

  Future<void> setSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkConfigsPrefs = prefs.containsKey('configs');

    if ((checkConfigsPrefs)) {
      configs = prefs.getString('configs')!;
    } else {
      await prefs.setString('configs', 'selene.hms-cloud.com:8882');
      configs = prefs.getString('configs')!;
    }
  }

  Widget _editWidget() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height / 12,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: MediaQuery.of(context).size.width / 1.3,
            child: ElevatedButton(
              onPressed: () {
                editConfigs();
              },
              child: const Icon(
                Icons.settings,
                size: 30,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      width: MediaQuery.of(context).size.width * 1.2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/hmc_logo.png',
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 2,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _contextWidget() {
    return Column(
      children: <Widget>[
        _entryFieldUsername("Usernamr", isPassword: false),
        SizedBox(height: 12),
        _entryFieldPassword("Password", isPassword: true),
      ],
    );
  }

  Widget _LoginButtonWidget() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 64,
        padding: EdgeInsets.symmetric(vertical: 1),
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: RoundedLoadingButton(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.blue,
          successColor: Colors.white,
          controller: _btnController,
          onPressed: () => checkLogin(),
          valueColor: Colors.black,
          borderRadius: 10,
          child: Text('''Login''',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ));
  }

  Widget _bottomWidget() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height / 8,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: MediaQuery.of(context).size.width / 1.8,
            child: Image.asset("assets/hmslogo.png", width: size.width * 0.38),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width / 80,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('1.0'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400], //
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryFieldUsername(String title, {bool isPassword = false}) {
    return Visibility(
        visible: true,
        child: SizedBox(
            child: TextFormField(
          controller: usernameController,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0),
                child: Image.asset(
                  "assets/username.png",
                  width: 1,
                  height: 1,
                )),
            hintText: 'Username',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            prefix: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0),
            ),
          ),
        )));
  }

  Widget _entryFieldPassword(String title, {bool isPassword = true}) {
    return Visibility(
        visible: true,
        child: TextFormField(
          obscureText: true,
          controller: passwordController,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0),
                child: Image.asset(
                  "assets/password.png",
                  width: 1,
                  height: 1,
                )),
            hintText: 'Password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            prefix: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
            ),
          ),
        ));
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

  void showErrorDialog(String error) {
    alertDialog(error, 'Error');
  }

  void showSuccessDialog(String success) {
    alertDialog(success, 'Success');
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

  Future<void> editConfigs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Icon icon = Icon(Icons.edit, color: Colors.lightBlue);
    if (prefs.getString('configs') != null) {
      configs = prefs.getString('configs')!;
    }
    setState(() {
      configsController..text = configs;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [icon, Text(" " + 'Edit Configs')]),
            content: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  readOnly: false,
                  controller: configsController,
                  decoration: InputDecoration(
                      labelText: 'Configs', hintText: "Enter Url"),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () async {},
                ),
              ],
            )),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  'Cancle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                //focusNode: focusNodes[5],
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  await prefs.setString('configs', configsController.text);
                  setState(() {
                    configs = configsController.text;
                  });
                  Navigator.pop(context);
                  alertDialog('Edit Successful', 'Success');
                },
              ),
            ],
          );
        });
  }

  Future<void> checkLogin() async {
    await showProgressLoading(false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.getString('configs') != null) {
        configs = prefs.getString('configs')!;
      }
      var url = Uri.parse('http://' + configs + '/API/api/User/Login');
      var headers = {'Content-Type': 'application/json'};

      UserLogin user = new UserLogin();
      setState(() {
        user.userName = 'U001';
        user.password = 'password1';
      });
      var jsonBody = jsonEncode(user);
      final encoding = Encoding.getByName('utf-8');

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        late ResultLogin result;
        setState(() {
          result = ResultLogin.fromJson(data);
        });

        await prefs.setString('token', result.accessToken!);
        await prefs.setString('username', result.user!.username);

        setState(() {
          usernameController.text = '';
          passwordController.text = '';
          _btnController.reset();
        });
        await showProgressLoading(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        await prefs.setString('token', '');
        await prefs.setString('username', '');
        setState(() {
          usernameController.text = '';
          passwordController.text = '';
          _btnController.reset();
        });
        await showProgressLoading(true);
        showErrorDialog('Username or Password Invalid.');
      }
    } catch (e) {
      setState(() {
        usernameController.text = '';
        passwordController.text = '';
        _btnController.reset();
      });
      await showProgressLoading(true);
      showErrorDialog('Error occured while checkLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 30),
              _editWidget(),
              _titleWidget(),
              Container(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 22),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _contextWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _LoginButtonWidget(),
              SizedBox(height: 24),
              _bottomWidget(),
            ],
          ),
        ),
      ),
    )));
  }
}

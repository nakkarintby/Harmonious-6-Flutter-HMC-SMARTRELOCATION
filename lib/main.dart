// @dart=2.9
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'package:test/routes.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  await Future.delayed(Duration(seconds: 3));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RELOCATION',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Login.routeName,
      routes: routes,
    );
  }
}

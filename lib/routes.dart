import 'package:test/screens/login.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  Login.routeName: (context) => Login(),
};

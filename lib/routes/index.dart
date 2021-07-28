import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voip_call_app/incoming_call.dart';
import 'package:flutter_voip_call_app/main.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => MyHomePage());
      case '/incoming_call':
        return CupertinoPageRoute(builder: (_) => IncomingCall());
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voip_call_app/incoming_call.dart';
import 'package:flutter_voip_call_app/main.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name);
    final route = uri.path;
    switch (route) {
      case '/':
        return CupertinoPageRoute(builder: (_) => MyHomePage());
      case '/incoming_call':
        final callerName = uri.queryParameters['callerName'];
        final callerId = uri.queryParameters['callerId'];
        return CupertinoPageRoute(builder: (_) => IncomingCall(callerName, callerId));
      // case "/outgoing_call":
      //   return Cup
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

import 'package:flutter/material.dart';

class IncomingCall extends StatefulWidget {
  const IncomingCall({Key key}) : super(key: key);

  @override
  _IncomingCallState createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incoming Call"),
      ),
    );
  }
}
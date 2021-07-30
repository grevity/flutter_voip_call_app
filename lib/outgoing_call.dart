import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voip_call_app/main.dart';
import 'package:sip_ua/sip_ua.dart';

class OutgoingCall extends StatefulWidget {
  final String fcmToken;
  final String callee;
  final String caller;
  OutgoingCall(this.fcmToken, this.callee, this.caller);
  @override
  _OutgoingCallState createState() => _OutgoingCallState();
}

class _OutgoingCallState extends State<OutgoingCall> implements SipUaHelperListener {
  String callingState = "Waiting...";

  sendNotification() async {
    await Dio().post("http://a6ec5eb990f3.ngrok.io/shared/notification", data: {
      "fcmToken": widget.fcmToken,
      "body": {
        "data": {
          "callerName": "Gurkaran Singh",
          "callerId": widget.caller
        }
      }
    });
    setState(() {
      callingState = "Connecting...";
    });
  }

  @override
  void initState() {
    super.initState();
    helper.addSipUaHelperListener(this);
    sendNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 42,),
              Text(
                "Calling ${widget.callee}",
                style: TextStyle(
                    fontSize: 32
                ),
              ),
              SizedBox(height: 12),
              Text(
                  callingState,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54
                  ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void callStateChanged(Call call, CallState state) {
    // TODO: implement callStateChanged
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    this.setState(() {
      callingState = "Ringing...";
    });
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    // TODO: implement registrationStateChanged
  }

  @override
  void transportStateChanged(TransportState state) {
  }
}

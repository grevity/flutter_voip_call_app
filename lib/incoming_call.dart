import 'package:flutter/material.dart';
import 'package:flutter_voip_call_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class IncomingCall extends StatefulWidget {
  final String callerName;
  final String callerId;
  const IncomingCall(this.callerName, this.callerId);

  @override
  _IncomingCallState createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> implements SipUaHelperListener {
  SharedPreferences _sharedPreferences;
  Call _call;
  bool connected = false;
  @override
  void initState() {
    super.initState();
    helper.addSipUaHelperListener(this);
    connectAndPing();
  }

  connectAndPing() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    UaSettings settings = UaSettings();
    settings.webSocketUrl ='wss://tryit.jssip.net:10443';
    settings.webSocketSettings.extraHeaders = {
      'Origin': ' https://tryit.jssip.net',
      'Host': 'tryit.jssip.net:10443'
    };
    settings.webSocketSettings.allowBadCertificate = true;
    settings.uri = "${_sharedPreferences.getString("uniqueName")}@tryit.jssip.net";
    settings.authorizationUser = _sharedPreferences.getString("username");
    settings.password = _sharedPreferences.getString("password");
    settings.displayName = _sharedPreferences.getString("displayName");
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    helper.start(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incoming Call"),
      ),
      body: connected ? Container(
          child: Column(
            children: [
              Text("${widget.callerName} is Calling"),
              SizedBox(height: 40,),
              Row(
                children: [
                  FlatButton(
                    onPressed: () {

                    },
                    child: Text("Reject"),
                  ),
                  FlatButton(
                    onPressed: () {
                      if(_call != null) {
                        _call.answer(helper.buildCallOptions());
                      }
                    },
                    child: Text("Answer"),
                  ),
                ],
              )
            ],
          )
      ) : Center(
        child: Text("Connecting Please wait"),
      )
    );
  }

  @override
  void callStateChanged(Call call, CallState state) {

  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // TODO: implement onNewMessage
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    // print("Registration Status: ${state.state.toString()}");
    print(EnumHelper.getName(RegistrationStateEnum.REGISTERED) == "REGISTERED");
    print(state.state == RegistrationStateEnum.REGISTERED);
    print(widget.callerId);
    if(state.state == RegistrationStateEnum.REGISTERED) {
      setState(() {
        connected = true;
      });
      helper.sendMessage("${widget.callerId}@tryit.jssip.net", "connected");
    }
  }

  @override
  void transportStateChanged(TransportState state) {
    // TODO: implement transportStateChanged
  }
}
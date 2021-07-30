import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_voip_call_app/outgoing_call.dart';
import 'package:flutter_voip_call_app/routes/index.dart' as GeneratedRoutes;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

final SIPUAHelper helper = SIPUAHelper();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: GeneratedRoutes.Router.generateRoute,
      initialRoute: "/",
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements SipUaHelperListener {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _fcmToken;
  SharedPreferences _sharedPreferences;
  BuildContext _registerDialogCtx;
  TextEditingController _uniqueNameTextController, _nameTextController, _passwordTextController, _displayNameTextController, _fcmTokenTextController, _calleeTextController;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken()
    .then((value) {
      print("[FCM Value] => $value");
      _fcmToken = value;
    });
    initData();
    helper.addSipUaHelperListener(this);
  }

  initData() async {
    SharedPreferences _preference = await SharedPreferences.getInstance();
    setState(() {
      _sharedPreferences = _preference;
      _uniqueNameTextController = TextEditingController(text: _preference.getString("uniqueName") ?? "unique.name.${Random().nextInt(999999).toString()}");
      _nameTextController = TextEditingController(text: _preference.getString("username") ?? "username");
      _passwordTextController = TextEditingController(text: _preference.getString("password") ?? "password");
      _displayNameTextController = TextEditingController(text: _preference.getString("displayName") ?? "RandomName#${Random().nextInt(9999).toString()}");
      _fcmTokenTextController = TextEditingController();
      _calleeTextController = TextEditingController();
    });
  }

  Future _register(ctx) async {
    try {
      if(_uniqueNameTextController.text == "" || _nameTextController.text == "" || _passwordTextController.text == "" || _displayNameTextController.text == "") {
        throw Exception("Please fill all the fields");
      }
      UaSettings settings = UaSettings();
      settings.webSocketUrl ='wss://tryit.jssip.net:10443';
      settings.webSocketSettings.extraHeaders = {
        'Origin': ' https://tryit.jssip.net',
        'Host': 'tryit.jssip.net:10443'
      };

      //set data to shared preference
      await Future.wait([
        _sharedPreferences.setString("uniqueName", _uniqueNameTextController.text),
        _sharedPreferences.setString("username", _nameTextController.text),
        _sharedPreferences.setString("password", _passwordTextController.text),
        _sharedPreferences.setString("displayName", _displayNameTextController.text),
      ]);

      settings.webSocketSettings.allowBadCertificate = true;
      settings.uri = "${_uniqueNameTextController.text}@tryit.jssip.net";
      settings.authorizationUser = _nameTextController.text;
      settings.password = _passwordTextController.text;
      settings.displayName = _displayNameTextController.text;
      settings.userAgent = 'Dart SIP Client v1.0.0';
      settings.dtmfMode = DtmfMode.RFC2833;
      helper.start(settings);
      showDialog(
        context: context,
        builder: (context) {
          _registerDialogCtx = context;
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Registering Please wait"),
                      SizedBox(width: 5,),
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.4,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe67e22)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          );
        }
      );
    } catch(e) {
      Scaffold.of(ctx).showSnackBar(
          SnackBar(
              content: Text(e?.message ?? e.toString()),
              backgroundColor: Colors.red,
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffe67e22)
          )
        ),
        labelStyle: TextStyle(
            color: Color(0xffe67e22)
        )
    );
    return SafeArea(
      child: Scaffold(
        body: _sharedPreferences == null ? Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.4,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe67e22)),
          ),
        ):
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          color: Colors.white,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 32),
                child: Text(
                  "You can directly go with these values and register or you can modify",
                  style: TextStyle(
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextField(
                  controller: _uniqueNameTextController,
                  decoration: inputDecoration.copyWith(
                      labelText: "Unique Name",
                  )
              ),
              SizedBox(height: 18,),
              TextField(
                  controller: _nameTextController,
                  decoration: inputDecoration.copyWith(
                      labelText: "Name",
                  )
              ),
              SizedBox(height: 18,),
              TextField(
                  controller: _displayNameTextController,
                  decoration: inputDecoration.copyWith(
                      labelText: "Display Name",
                  )
              ),
              SizedBox(height: 18,),
              TextField(
                  controller: _passwordTextController,
                  decoration: inputDecoration.copyWith(
                      labelText: "Password",
                  )
              ),
              SizedBox(height: 18,),
              Text(
                "Note: websocket, origin and host are hardcoded into the source code, edit source code to use custom server",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                      child: Builder(
                        builder: (ctx) => FlatButton(
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          color: Color(0xffe67e22),
                          disabledColor: Color(0xffe67e22).withOpacity(0.4),
                          onPressed: () => _register(ctx),
                        ),
                      )
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 18,),
              Container(
                padding: EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(child: _fcmToken == null ? Text("Loading...") : Text(_fcmToken)),
                    Builder(
                      builder: (context) {
                        return IconButton(icon: Icon(Icons.copy), onPressed: _fcmToken == null ? null : () async {
                          await Clipboard.setData(ClipboardData(text: _fcmToken));
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Copied to clipboard, now share it with the person you want to receive call from")));
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 18,),
              TextField(
                  controller: _fcmTokenTextController,
                  decoration: inputDecoration.copyWith(
                    labelText: "Fcm Token of Callee",
                  )
              ),
              SizedBox(height: 18,),
              TextField(
                  controller: _calleeTextController,
                  decoration: inputDecoration.copyWith(
                    labelText: "Callee unique name",
                  )
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                      child: Builder(
                        builder: (ctx) => FlatButton(
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text(
                            "Call",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          color: Color(0xffe67e22),
                          disabledColor: Color(0xffe67e22).withOpacity(0.4),
                          onPressed: () {
                            if(_fcmTokenTextController.text == "" || _calleeTextController.text == "") {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("Please fill all the fields"))
                              );
                            } else {
                              helper.removeSipUaHelperListener(this);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => OutgoingCall(_fcmTokenTextController.text, _calleeTextController.text, _sharedPreferences.getString("uniqueName"))
                                  )
                              );
                            }
                          }
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void callStateChanged(Call call, CallState state) {
    // TODO: implement callStateChanged
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // TODO: implement onNewMessage
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    print("Registration Status: ${state.state.toString()}");
    if(state.state == RegistrationStateEnum.REGISTERED) {
      if(_registerDialogCtx != null) {
        Navigator.pop(_registerDialogCtx);
        setState(() {
          _registerDialogCtx = null;
        });
      }
    }
  }

  @override
  void transportStateChanged(TransportState state) {
    // TODO: implement transportStateChanged
  }
}

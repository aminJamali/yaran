import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  String apiToken;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  UserBloc _userBloc;
  _checkNavigator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('apiToken');
    if (apiToken != null) {
      Navigator.pushReplacementNamed(context, '/drawer');
    } else {
      Navigator.pushReplacementNamed(context, '/user_login_page');
    }
  }

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(CheckConnectionEvent());
  }

  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _userBloc,
        listener: (context, state) {
          if (state is CheckConnectionState) {
            _checkConnection(state.isConnected);
          }
        },
        builder: (context, state) {
          return new Scaffold(
            key: _scaffoldKey,
            backgroundColor: maincolor,
            body: _body(),
          );
        });
  }

  _checkConnection(bool isConnected) {
    if (isConnected != true) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                    height: 50,
                    color: maincolor,
                    child: Center(
                      child: new Row(
                        children: <Widget>[
                          Text("اتصال اینترنت خود را بررسی نمایید",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          new GestureDetector(
                            onTap: () {
                              _userBloc.add(CheckConnectionEvent());
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 30),
                              child: new Text("تلاش دوباره",
                                  style: new TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    )));
          });
    } else {
      _checkNavigator();
    }
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40),
          child: new Text(
            "صندوق شهدای موردک",
            style: new TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
            ),
          ),
        ),
      ],
    );
  }
}

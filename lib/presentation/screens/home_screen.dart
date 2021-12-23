import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/dashboard_dtos/dashborad_dto.dart';
import 'package:moordak/data/models/dashboard_model.dart';
import 'package:moordak/logic/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:persian_number_utility/persian_number_utility.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  SharedPreferences _preferences;
  DashboardBloc _dashboardBloc;
  DashBoardModel _dashBoardModel;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    _getPreferences();
  }

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _dashboardBloc.add(
      DashBoardGetInfoEvent(
        new DashBoradDto(_preferences.getString('apiToken')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _dashboardBloc,
        listener: (context, state) {
          if (state is DashBoardExceptionState) {
            _exceptionState(state.message);
          }
        },
        builder: (context, state) {
          if (state is DashBoardGetInfoState) {
            _getInfo(state.dashBoardModel);
          }
          return new Scaffold(
            key: _scaffoldKey,
            appBar: _MyAppBar(),
            body: _isLoading == true
                ? new Center(
                    child: new CircularProgressIndicator(
                      color: maincolor,
                    ),
                  )
                : new Column(
                    children: [
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _showUsers(),
                          _showCharity(),
                        ],
                      ),
                      _showTransactions(),
                      _monthTransactions(),
                    ],
                  ),
          );
        });
  }

  _exceptionState(String exception) async {
    _isLoading = false;
    if (exception == '401') {
      _preferences = await SharedPreferences.getInstance();
      _preferences.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(exception),
        ),
      );
    }
  }

  _getInfo(DashBoardModel dashBoardModel) {
    _isLoading = false;
    if (dashBoardModel != null) {
      _dashBoardModel = dashBoardModel;
    }
  }

  Widget _showCharity() {
    return new InkWell(
      onTap: () {},
      child: Card(
        color: Colors.greenAccent[400],
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: new Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * .45,
          height: MediaQuery.of(context).size.height * 0.2,
          child: new Column(
            children: [
              new Icon(
                CupertinoIcons.moon_stars,
                color: Colors.white,
                size: 40,
              ),
              new Container(
                margin: EdgeInsets.only(top: 15),
              ),
              new Text(
                '${_dashBoardModel.charityPrice.toString().seRagham()} ریال پرداخت خیریه',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _monthTransactions() {
    return new InkWell(
      onTap: () {
        _preferences.remove('apiToken');
      },
      child: Card(
        color: Colors.red[400],
        child: new Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          child: new Column(
            children: [
              new Text(
                '${_dashBoardModel.thisMonthPayments.toString().seRagham()} ریال پرداخت در این ماه',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 30),
              ),
              new Icon(
                CupertinoIcons.calendar_today,
                color: Colors.white,
                size: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showTransactions() {
    return new InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.deepPurple[400],
        child: new Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          child: new Column(
            children: [
              new Text(
                '${_dashBoardModel.totalPrice.toString().seRagham()} ریال پرداخت کلی',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 30),
              ),
              new Icon(
                CupertinoIcons.money_dollar_circle,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showUsers() {
    return new InkWell(
      child: Card(
        color: Colors.orange[400],
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: new Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * .45,
          height: MediaQuery.of(context).size.height * 0.2,
          child: new Column(
            children: [
              new Icon(
                CupertinoIcons.person_3,
                color: Colors.white,
                size: 40,
              ),
              new Container(
                margin: EdgeInsets.only(top: 30),
              ),
              new Text(
                '${_dashBoardModel.memberCount} کاربر',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      leading: new IconButton(
        onPressed: () {
          DrawerScreenState.drawerKey.currentState.openDrawer();
        },
        icon: Icon(Icons.menu),
      ),
      elevation: 0,
      title: new Text(
        'صفحه اصلی',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

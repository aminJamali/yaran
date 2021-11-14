import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/user_dtos/get_user_info_dto.dart';
import 'package:moordak/data/dtos/user_dtos/user_register_dto.dart';
import 'package:moordak/data/models/user_model.dart';
import 'package:moordak/logic/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/screens/drawer.dart';
import 'package:moordak/presentation/screens/transactions_screens/transaction_screen.dart';
import 'package:moordak/presentation/screens/user_screens/details_user.dart';
import 'package:moordak/presentation/list_items/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
UserBloc _userBloc;
bool _isLoading;
List<UserModel> _finalUsers = [];
SharedPreferences _preferences;
int _pageNumber = 0;
Map<String, AppBar> _appBarList;
String _currentAppBar = 'mainAppBar';
AppBar _searchAppBar, _mainAppBar;
ScrollController _listScrollController = new ScrollController();

class _UserScreenState extends State<UserScreen>
    with AutomaticKeepAliveClientMixin<UserScreen> {
  @override
  void initState() {
    super.initState();

    _userBloc = BlocProvider.of<UserBloc>(context);

    _getPreferences();
    _listScrollController.addListener(() {
      double maxScroll = _listScrollController.position.maxScrollExtent;
      double currentScroll = _listScrollController.position.pixels;

      if (maxScroll - currentScroll <= 200) {
        if (!_isLoading) {
          _userBloc.add(
            new GetAllUsersEvent(
              new GetUserInfoDto(
                apiToken: _preferences.getString('apiToken'),
                pageNumber: _pageNumber++,
              ),
            ),
          );
        }
      }
    });
    _searchAppBar = new AppBar(
      title: _buildSearch(),
      elevation: 5,
      backgroundColor: Colors.white,
      leading: new GestureDetector(
          child: new Padding(
            padding: const EdgeInsets.only(right: 12),
            child: new Icon(Icons.arrow_back, color: new Color(0xff075E54)),
          ),
          onTap: () {
            setState(() {
              _currentAppBar = 'mainAppBar';
            });
          }),
    );
    _mainAppBar = new AppBar(
      title: Text(
        'کاربران',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      elevation: 5,
      leading: new IconButton(
        onPressed: () {
          DrawerScreenState.drawerKey.currentState.openDrawer();
        },
        icon: Icon(Icons.menu),
      ),
      backgroundColor: maincolor,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            new IconButton(
              onPressed: () {
                setState(() {
                  _currentAppBar = 'searchAppBar';
                });
              },
              icon: new Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
    _appBarList = <String, AppBar>{
      'mainAppBar': _mainAppBar,
      'searchAppBar': _searchAppBar
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserExceptionState) {
          _exceptionState(state.text);
        }
      },
      builder: (context, state) {
        if (state is GetAllUsersState) {
          _getAllUsers(state.users);
        } else if (state is GetAllUsersBySearchState) {
          _getAllUsers(state.users);
        } else if (state is UserLoadingState) {
          _isLoading = true;
        }

        return Scaffold(
          appBar: _appBarList[_currentAppBar],
          floatingActionButton: _floatingActionButton(),
          body: new RefreshIndicator(
            child: _isLoading == true && _finalUsers.length == 0
                ? Center(
                    child: new CircularProgressIndicator(
                      color: maincolor,
                    ),
                  )
                : _finalUsers.length > 0
                    ? Scrollbar(
                        child: ListView.builder(
                          controller: _listScrollController,
                          padding: EdgeInsets.only(bottom: 50),
                          itemCount: _finalUsers.length,
                          itemBuilder: (context, index) {
                            return new UserViewModel(
                              onItemPressed: () {
                                _onItemLongPressed(_finalUsers[index].id);
                              },
                              userModel: _finalUsers[index],
                              onItemClicked: () {
                                _onItemClicked(_finalUsers[index]);
                              },
                            );
                          },
                        ),
                      )
                    : _buildEmpty(),
            onRefresh: () async {
              await _userBloc.add(
                new GetAllUsersEvent(
                  new GetUserInfoDto(
                    apiToken: _preferences.getString('apiToken'),
                    pageNumber: _pageNumber = 0,
                  ),
                ),
              );
              return null;
            },
          ),
        );
      },
    );
  }

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _userBloc.add(
      new GetAllUsersEvent(
        new GetUserInfoDto(
          apiToken: _preferences.getString('apiToken'),
          pageNumber: _pageNumber = 0,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return new Center(
      child: new Text(
        'موردی برای نمایش وجود ندارد',
        style: new TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return new TextField(
      onChanged: (text) =>
          new Timer(new Duration(seconds: 1), _onSearchTextChanged(text)),
      decoration: new InputDecoration(
          border: InputBorder.none, hintText: "جستجو کنید..."),
    );
  }

  _onSearchTextChanged(String searchText) {
    _pageNumber = 0;
    _finalUsers.clear();
    _userBloc.add(
      new GetAllUsersBySearchEvent(
        new GetUserInfoDto(
          apiToken: _preferences.getString('apiToken'),
          pageNumber: _pageNumber = 0,
          searchText: searchText,
        ),
      ),
    );
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

  _getAllUsers(List<UserModel> _users) {
    _isLoading = false;
    if (_users.length > 0 && _pageNumber == 0) {
      _finalUsers = _users;
    } else if (_users.length > 0) {
      _finalUsers.addAll(_users);
    }
  }

  _onItemClicked(UserModel _userItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Directionality(
          textDirection: TextDirection.rtl,
          child: DetailsUserScreen(
            userModel: _userItem,
          ),
        ),
      ),
    );
  }

  _onItemLongPressed(String userId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              new MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) => TransactionBloc(),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TransactionsScreen(
                              userId: userId,
                            ),
                          ),
                        ),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(Icons.list, color: Colors.green),
                    new Text(
                      'سوابق پرداخت',
                      style: new TextStyle(
                        fontSize: 16,
                        color: maincolor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _floatingActionButton() {
    return new FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register_page');
      },
      backgroundColor: maincolor,
      child: new Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

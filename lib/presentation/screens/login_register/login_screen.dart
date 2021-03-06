import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/user_dtos/user_login_dto.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/components/password_input.dart';
import 'package:moordak/presentation/components/text_input.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController _userNameController = new TextEditingController();
TextEditingController _passWordController = new TextEditingController();

final _formKey = GlobalKey<FormState>();

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
UserBloc _userBloc;
bool _isLoading;
SharedPreferences _preferences;

class _LoginScreenState extends State<LoginScreen> {
  AnimationController _loginButtonController;
  @override
  void initState() {
    super.initState();

    _userBloc = BlocProvider.of<UserBloc>(context);
    _checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserExceptionState) {
          _isLoading = false;
          print(state.text);
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(state.text)));
        } else if (state is UserLoginState) {
          print('UserLoginState');
          _userLogin(state.apiToken, context);
        }
      },
      builder: (context, state) {
        if (state is UserLoadingState) {
          _isLoading = true;
        }
        return Scaffold(
          backgroundColor: bodycolor,
          key: _scaffoldKey,
          body: new Stack(
            alignment: Alignment.topCenter,
            children: [
              _background(context),
              _form(context),
            ],
          ),
        );
      },
    );
  }

  Widget _submit(context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          UserLoginDto _userLoginDto = new UserLoginDto(
            _userNameController.text.toString(),
            _passWordController.text.toString(),
          );
          _userBloc.add(new UserLoginEvent(_userLoginDto));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: 230.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: maincolor,
        ),
        child: Center(
          child: _isLoading == true
              ? new CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  '????????',
                  style: TextStyle(
                    fontFamily: 'IRANSans',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  _userLogin(apiToken, context) async {
    _isLoading = false;
    print("here api token ${apiToken}");
    if (apiToken != null && apiToken != "WrongUserOrPassword") {
      _preferences.setString('apiToken', apiToken);
      _preferences.setString('userName', _userNameController.text);
      _preferences.setString('password', _passWordController.text);
      _userNameController.clear();
      _passWordController.clear();
      Navigator.pushReplacementNamed(context, '/drawer');
    } else if (apiToken == "WrongUserOrPassword") {
      Toast.show("?????? ???????????? ???? ?????????????? ????????????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    } else {
      Toast.show("???????????? ???????????? ??????", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  Widget _background(context) {
    return Container(
        height: MediaQuery.of(context).size.height * .30,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: maincolor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(700, 200),
                bottomRight: Radius.elliptical(700, 200))),
        child: Text('???????? ??????????',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )));
  }

  Widget _form(context) {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(
          right: 25, left: 25, top: MediaQuery.of(context).size.height * .17),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InputFieldArea(
              icon: Icons.person,
              lable: '?????? ???????????? (???? ??????)',
              controller: _userNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return '???????? ?????? ?????? ???? ???? ????????';
                }
                return null;
              },
              maxLength: 10,
              textInputType: TextInputType.number,
            ),
            new PasswordInputFieldArea(
              lable: '?????? ????????',
              maxLength: 20,
              obscure: true,
              controller: _passWordController,
              validator: (value) {
                if (value.isEmpty) {
                  return '???????? ?????? ?????? ???? ???? ????????';
                }
                return null;
              },
              icon: Icons.password,
              textInputType: TextInputType.text,
            ),
            _submit(context),
          ],
        ),
      ),
    ));
  }

  void _checkRememberMe() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.getString('userName') != null &&
        _preferences.getString('password') != null) {
      setState(() {
        _userNameController.text = _preferences.getString('userName');
        _passWordController.text = _preferences.getString('password');
      });
    }
  }
}

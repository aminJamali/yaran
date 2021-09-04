import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/user_dtos/user_register_dto.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/components/text_input.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

TextEditingController _nationCodeController = new TextEditingController();
TextEditingController _numberController = new TextEditingController();
TextEditingController _firstNameController = new TextEditingController();
TextEditingController _lastNameController = new TextEditingController();
TextEditingController _fatherNameController = new TextEditingController();
TextEditingController _emailAddressController = new TextEditingController();
TextEditingController _postController = new TextEditingController();

final _formKey = GlobalKey<FormState>();

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
UserBloc _userBloc;
bool _isLoading;

class _RegisterScreenState extends State<RegisterScreen> {
  SharedPreferences _preferences;
  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserExceptionState) {
          _exceptionState(state.text);
        } else if (state is UserRegisterState) {
          _userRegister(state.isInserted, context);
        }
      },
      builder: (context, state) {
        if (state is UserLoadingState) {
          _isLoading = true;
        }
        return Scaffold(
          backgroundColor: bodycolor,
          key: _scaffoldKey,
          appBar: _MyAppBar(),
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
}

_userRegister(isSuccesed, context) {
  _isLoading = false;
  if (isSuccesed == true) {
    Toast.show("با موفقیت ثبت شد", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    _formKey.currentState.reset();
    _nationCodeController.clear();
    _numberController.clear();
    _emailAddressController.clear();
    _firstNameController.clear();
    _fatherNameController.clear();
    _lastNameController.clear();
  } else {
    Toast.show("عملیات ناموفق بود", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
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
  );
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
            lable: 'کد ملی',
            controller: _nationCodeController,
            validator: (value) {
              if (value.isEmpty) {
                return 'لطفا این فرم را پر کنید';
              }
              return null;
            },
            maxLength: 10,
            textInputType: TextInputType.number,
          ),
          new InputFieldArea(
            lable: 'شماره تماس',
            maxLength: 11,
            controller: _numberController,
            validator: (value) {
              if (value.isEmpty) {
                return 'لطفا این فرم را پر کنید';
              }
              return null;
            },
            icon: Icons.call,
            textInputType: TextInputType.number,
          ),
          new InputFieldArea(
            lable: 'نام',
            maxLength: 20,
            controller: _firstNameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'لطفا این فرم را پر کنید';
              }
              return null;
            },
            icon: Icons.person,
            textInputType: TextInputType.text,
          ),
          new InputFieldArea(
            lable: 'نام خانوادگی',
            maxLength: 20,
            controller: _lastNameController,
            icon: Icons.people_alt_outlined,
            validator: (value) {
              if (value.isEmpty) {
                return 'لطفا این فرم را پر کنید';
              }
              return null;
            },
            textInputType: TextInputType.text,
          ),
          new InputFieldArea(
            lable: 'نام پدر',
            maxLength: 20,
            controller: _fatherNameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'لطفا این فرم را پر کنید';
              }
              return null;
            },
            icon: Icons.male,
            textInputType: TextInputType.text,
          ),
          new InputFieldArea(
            lable: 'آدرس ایمیل (اختیاری)',
            icon: Icons.email,
            controller: _emailAddressController,
            textInputType: TextInputType.emailAddress,
          ),
          _submit(context),
        ],
      ),
    ),
  ));
}

Widget _submit(context) {
  return InkWell(
    onTap: () async {
      if (_formKey.currentState.validate()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserRegisterDto _userRegisterDto = new UserRegisterDto(
          nationalCode: _nationCodeController.text,
          mobileNumber: _numberController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          roleName: "member",
          fatherName: _fatherNameController.text,
          email: _emailAddressController.text != null
              ? _emailAddressController.text
              : null,
          apiToken: prefs.getString('apiToken'),
        );

        _userBloc.add(new UserRegisterEvent(_userRegisterDto));
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
                'ثبت نام',
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

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      elevation: 0,
      title: new Text(
        'افزودن کاربر جدید',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

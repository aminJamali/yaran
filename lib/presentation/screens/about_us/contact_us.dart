import 'package:flutter/material.dart';
import 'package:moordak/presentation/components/text_input.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/screens/drawer.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      backgroundColor: bodycolor,
      body: new Stack(
        alignment: Alignment.topCenter,
        children: [
          _background(context),
          _form(context),
        ],
      ),
    );
  }
}

Widget _background(context) {
  return Container(
    height: MediaQuery.of(context).size.height * .30,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(bottom: 50),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: maincolor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(700, 200),
            bottomRight: Radius.elliptical(700, 200))),
    child: new Text(
      'برای تماس با ما فرم زیر را پر کنید',
      style: new TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ),
  );
}

Widget _submit(context) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
      width: 230.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: maincolor,
      ),
      child: Center(
        child: Text(
          'ارسال',
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

Widget _form(context) {
  return SingleChildScrollView(
      child: Container(
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    margin: EdgeInsets.only(
        right: 25, left: 25, top: MediaQuery.of(context).size.height * .14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new InputFieldArea(
          icon: Icons.person,
          lable: 'عنوان پیام',
          maxLength: 8,
          textInputType: TextInputType.text,
        ),
        new InputFieldArea(
          lable: 'شرح',
          maxLength: 10,
          icon: Icons.person,
          textInputType: TextInputType.text,
        ),
        _submit(context),
      ],
    ),
  ));
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
        'ارتباط با ما',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

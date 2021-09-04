import 'package:flutter/material.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/screens/drawer.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      backgroundColor: bodycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _about(),
            _site(),
          ],
        ),
      ),
    );
  }
}

Widget _site() {
  return new Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: 20),
    child: new Text(
      'borhanrayane.com',
      style: new TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: maincolor,
      ),
    ),
  );
}

Widget _about() {
  return new Container(
    margin: EdgeInsets.all(6),
    padding: EdgeInsets.all(5),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: new SingleChildScrollView(
      child: new Text(
        'شرکت برهان رایانه زاگرس در سال 1400 شمسی با هدف پوشش نیازهای بخش فناوری اطلاعات کشور تاسیس شد',
        style: new TextStyle(
          fontSize: 16,
          color: maincolor,
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
      leading: new IconButton(
        onPressed: () {
          DrawerScreenState.drawerKey.currentState.openDrawer();
        },
        icon: Icon(Icons.menu),
      ),
      elevation: 0,
      title: new Text(
        'درباره ما',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

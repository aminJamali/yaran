import 'package:flutter/material.dart';
import 'package:moordak/presentation/consts/colors.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF3366FF),
              const Color(0xFF00CCFF),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.decal),
      ),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'شهدای موردک',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('صفحه اصلی', Icons.home, 'home'),
          sliderItem('کاربران', Icons.add_circle, 'users'),
          sliderItem('تراکنش ها', Icons.add_circle, 'transactions'),
          sliderItem('وام ها', Icons.add_circle, 'loans'),
          Divider(
            height: 5,
            color: bodycolor,
          ),
          sliderItem('درباره ما', Icons.list, 'about_us'),
          sliderItem('تماس با ما', Icons.call, 'contact_us'),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons, String key) => ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      onTap: () {
        onItemClick(key);
      });
}

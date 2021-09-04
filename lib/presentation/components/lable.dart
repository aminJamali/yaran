import 'package:flutter/material.dart';
import 'package:moordak/presentation/consts/colors.dart';

class Lable extends StatelessWidget {
  final String title, description;

  const Lable({Key key, this.title, this.description}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListTile(
      title: new Text(
        title,
        style: new TextStyle(
          fontSize: 16,
          color: Colors.grey[500],
        ),
      ),
      trailing: new Text(
        description,
        style: new TextStyle(
          fontSize: 16,
          color: maincolor,
        ),
      ),
    );
  }
}

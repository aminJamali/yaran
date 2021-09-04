import 'package:flutter/material.dart';
import 'package:moordak/data/models/user_model.dart';
import 'package:moordak/presentation/components/lable.dart';
import 'package:moordak/presentation/consts/colors.dart';

class DetailsUserScreen extends StatefulWidget {
  final UserModel userModel;

  const DetailsUserScreen({this.userModel});
  @override
  _DetailsUserScreenState createState() => _DetailsUserScreenState();
}

class _DetailsUserScreenState extends State<DetailsUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: [
            new Lable(
              title: 'نام :',
              description:
                  '${widget.userModel.firstName} ${widget.userModel.lastName != null ? widget.userModel.lastName : ""}',
            ),
            new Divider(
              height: 5,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'کد ملی :',
              description: widget.userModel.nationalCode,
            ),
            new Divider(
              height: 5,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'نام کاربری :',
              description: widget.userModel.userName,
            ),
            new Divider(
              height: 5,
              color: Colors.grey[400],
            ),
            new Lable(
              title: 'شماره موبایل :',
              description: widget.userModel.mobileNumber,
            ),
            new Divider(
              height: 5,
              color: Colors.grey[400],
            ),
          ],
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
      elevation: 0,
      title: new Text(
        'اطلاعات کاربر',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}

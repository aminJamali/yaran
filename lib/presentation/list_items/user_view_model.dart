import 'package:flutter/material.dart';
import 'package:moordak/data/models/user_model.dart';

class UserViewModel extends StatelessWidget {
  final onItemPressed;
  final onItemClicked;
  final UserModel userModel;

  const UserViewModel({this.onItemPressed, this.onItemClicked, this.userModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        new ListTile(
          title: _title(),
          onTap: onItemClicked,
          subtitle: _position(),
          trailing: new IconButton(
            onPressed: onItemPressed,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        new Divider(
          height: 4,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _position() {
    return new Text(
      '${userModel.nationalCode != null ? userModel.nationalCode : "نامشخش"}',
      style: new TextStyle(
        fontSize: 14,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _title() {
    return new Text(
      "${userModel.firstName} ${userModel.lastName == null ? " " : userModel.lastName}",
      style: new TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }
}

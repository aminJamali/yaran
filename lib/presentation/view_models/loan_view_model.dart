import 'package:flutter/material.dart';
import 'package:moordak/data/models/loan_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class LoanViewModel extends StatelessWidget {
  final LoanModel loanModel;
  final onItemLongPressed, onItemClicked;

  const LoanViewModel(
      {this.loanModel, this.onItemClicked, this.onItemLongPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new ListTile(
          onLongPress: onItemLongPressed,
          onTap: onItemClicked,
          title: Row(
            children: [
              _name(),
              new SizedBox(
                width: 30,
              ),
              _isFinished(),
            ],
          ),
          subtitle: _price(),
          trailing: _getDate(),
        ),
        new Divider(
          height: 4,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _getDate() {
    return new Text(
      loanModel.getDate.toPersianDate(),
      style: new TextStyle(
        fontSize: 12,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _price() {
    return Row(
      children: [
        new Text(
          loanModel.loanVal.toString().seRagham(separator: ","),
          style: new TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
        new Text(
          'ریال ',
          style: new TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _isFinished() {
    return new Container(
      padding: EdgeInsets.all(3),
      child: new Text(
        loanModel.isFinished == true ? "تمام شده" : "تمام نشده",
        style: new TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _name() {
    return new Text(
      "${loanModel.firstName} ${loanModel.lastName == null ? "" : loanModel.lastName}",
      style: new TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }
}

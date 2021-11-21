import 'package:flutter/material.dart';
import 'package:moordak/data/models/transaction_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class TransactionViewModel extends StatelessWidget {
  final onItemLongPressed;
  final onItemClicked;
  final TransactionModel transactionModel;

  const TransactionViewModel(
      {Key key,
      this.onItemLongPressed,
      this.onItemClicked,
      this.transactionModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        new ListTile(
          onTap: onItemClicked,
          title: Row(
            children: [
              _title(),
              new SizedBox(
                width: 30,
              ),
              _isCharity(),
            ],
          ),
          trailing: new IconButton(
            onPressed: onItemLongPressed,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _price(),
              _date(),
            ],
          ),
        ),
        new Divider(
          height: 4,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _isCharity() {
    return new Container(
      padding: EdgeInsets.all(3),
      child: new Text(
        transactionModel.isCharity == true ? "خیریه" : "پرداختی",
        style: new TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _date() {
    return new Text(
      transactionModel.payDate.toPersianDate(),
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
          transactionModel.payVal.toString().seRagham(separator: ","),
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

  Widget _title() {
    return new Text(
      "${transactionModel.firstName} ${transactionModel.lastName == null ? "" : transactionModel.lastName}",
      style: new TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }
}

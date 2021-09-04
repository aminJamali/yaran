import 'package:flutter/material.dart';
import 'package:moordak/data/models/loan_Installments_model.dart';

import 'package:persian_number_utility/persian_number_utility.dart';

class InstallmentViewModel extends StatelessWidget {
  final LoanInstallmentsModel loanInstallmentsModel;
  final onItemLongPressed, onItemClicked;

  const InstallmentViewModel(
      {this.loanInstallmentsModel, this.onItemClicked, this.onItemLongPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new ListTile(
          onLongPress: onItemLongPressed,
          onTap: onItemClicked,
          title: _price(),
          subtitle: _getDate(),
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
      loanInstallmentsModel.installmentDate.toPersianDate(),
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
          loanInstallmentsModel.payVal.toString().seRagham(separator: ","),
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
}

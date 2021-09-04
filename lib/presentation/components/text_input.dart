import 'package:flutter/material.dart';

class InputFieldArea extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String lable;
  final TextInputType textInputType;
  final IconData icon;
  final int maxLength;

  final validator, onChanged, inputFormatter;

  InputFieldArea({
    this.inputFormatter,
    this.onChanged,
    this.hint,
    this.icon,
    this.lable,
    this.controller,
    this.maxLength,
    this.validator,
    this.textInputType,
  });
  @override
  _InputFieldAreaState createState() => _InputFieldAreaState();
}

class _InputFieldAreaState extends State<InputFieldArea> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      child: new TextFormField(
        maxLength: widget.maxLength,
        controller: widget.controller,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatter,
        keyboardType: widget.textInputType,
        autofocus: false,
        validator: widget.validator,
        style: const TextStyle(color: Colors.black),
        decoration: new InputDecoration(
            labelText: widget.lable,
            icon: new Icon(
              widget.icon,
              color: Colors.blue,
            ),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
              color: Colors.grey,
            )),
            focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.blue)),
            errorStyle: new TextStyle(color: Colors.red),
            errorBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.red)),
            focusedErrorBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.red)),
            hintText: widget.hint,
            hintStyle: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
            contentPadding:
                const EdgeInsets.only(top: 15, right: 0, bottom: 20, left: 5)),
      ),
    );
  }
}

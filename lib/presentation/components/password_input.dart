import 'package:flutter/material.dart';

class PasswordInputFieldArea extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String lable;
  final TextInputType textInputType;
  final IconData icon;
  final int maxLength;
  bool obscure;
  final validator, onChanged, inputFormatter;

  PasswordInputFieldArea({
    this.inputFormatter,
    this.onChanged,
    this.hint,
    this.icon,
    this.lable,
    this.controller,
    this.maxLength,
    this.validator,
    this.textInputType,
    this.obscure,
  });
  @override
  _PasswordInputFieldAreaState createState() => _PasswordInputFieldAreaState();
}

class _PasswordInputFieldAreaState extends State<PasswordInputFieldArea> {
  void _toggle() {
    setState(() {
      widget.obscure = !widget.obscure;
    });
  }

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
        obscureText: widget.obscure == null ? false : widget.obscure,
        autofocus: false,
        validator: widget.validator,
        style: const TextStyle(color: Colors.black),
        decoration: new InputDecoration(
            labelText: widget.lable,
            suffixIcon: widget.obscure == true
                ? new IconButton(
                    onPressed: _toggle,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.red,
                    ),
                  )
                : new IconButton(
                    onPressed: _toggle,
                    icon: Icon(Icons.remove_red_eye, color: Colors.green),
                  ),
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

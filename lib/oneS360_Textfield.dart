import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarCodeTextField extends Padding {
  BarCodeTextField(
      {
        String label,
        String hint,
      TextInputType keyboardType,
        EdgeInsetsGeometry padding = const EdgeInsets.only(left: 15,top: 15,right: 15,bottom: 0),
      BuildContext context,
      TextEditingController controller,
      Function(String) validator})
      : super(
    padding : padding,
          child: TextFormField(
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(context).nextFocus();
            },

            //  scrollPadding: EdgeInsets.all(180),

            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: label,
            ),
            validator: validator,
            controller: controller,
            scrollPadding: EdgeInsets.only(bottom: 250),
          )

        );
}

class OneS360PasswordField extends StatefulWidget {
  final IconData icon;
  final String label;
  final TextInputType keyboardType;
  final BuildContext context;
  final TextEditingController controller;
  final Function(String) validator;

  OneS360PasswordField({
    this.icon,
    this.label,
    this.keyboardType,
    this.context,
    this.controller,
    this.validator,
  });

  @override
  _OneS360PasswordFieldState createState() => _OneS360PasswordFieldState();
}

class _OneS360PasswordFieldState extends State<OneS360PasswordField> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _show,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          labelText: widget.label,
          focusColor: Theme.of(context).primaryColor,
          suffix: GestureDetector(
            child: Icon(_show ? Icons.visibility_off : Icons.remove_red_eye,
                color: Theme.of(context).primaryColor, size: 17),
            onTap: () => setState(() => _show = !_show),
          )),
      validator: widget.validator,
      controller: widget.controller,
      scrollPadding: EdgeInsets.all(150),
    );
  }
}

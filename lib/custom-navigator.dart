import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  static navigateTo(context, widget) {

    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).requestFocus(FocusNode());

    return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget)
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const appScreenLineDivider = Padding(
    padding: EdgeInsets.fromLTRB(10.0, 00.0, 10.0, 0.0),
    child: Divider(
      color: Colors.black,
      thickness: 1.0,
    ),
  );
}

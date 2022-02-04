import 'package:flutter/cupertino.dart';

class Echo {
  Echo(String text, {BuildContext context}) {
    if (context == null)
      print('------> $text');
    else
      print('------>${context.widget.toStringShort()} $text');
  }
}


import 'package:flutter/material.dart';


class CustomTextContainer extends StatelessWidget {
  CustomTextContainer({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.all(4),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            '$value',
            style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          Text('$label',
              style: TextStyle(
                color: Colors.white,
                fontSize: 6,
              ))
        ]));
  }
}

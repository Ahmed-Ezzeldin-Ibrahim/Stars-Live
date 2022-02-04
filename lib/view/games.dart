import 'package:flutter/material.dart';

class GamesWidget extends StatefulWidget {
  @override
  _GamesWidgetState createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('قريبا'),
        ),
      ),
    );
  }
}

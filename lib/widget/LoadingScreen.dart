import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Widget child;
  final bool loading;
  LoadingScreen({@required this.child,this.loading = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          loading?Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.3),
            ),
          ):const SizedBox(),
          loading?Positioned(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }
}

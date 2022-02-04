import 'package:flutter/material.dart';

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({this.icon, this.text});
}

class MenuItems {
  static const List<MenuItem> items = [
    swtichCamera,
    share,
    mute,
  ];

  static const swtichCamera = MenuItem(
    text: "Switch Camera",
    icon: Icons.switch_camera,
  );
  static const share = MenuItem(
    text: "Share",
    icon: Icons.share,
  );
  static const mute = MenuItem(
    text: "Mute",
    icon: Icons.mic_external_off,
  );
}

import 'package:flutter/material.dart';

class LevelColors extends StatelessWidget {
  final int level;
  LevelColors({this.level});

  static LinearGradient getColor(int level) {
    if (-1 < level && level < 20) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF63D290), Color(0xFF5FD2B1)],
      );
    } else if (level < 40) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF68A6E7), Color(0xFF5682CD)],
      );
    } else if (level < 60) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7A14F2), Color(0xFF380574)],
      );
    } else if (level < 80) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7A14F2), Color(0xFF3778EA)],
      );
    } else if (level < 100) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF67347), Color(0xFFFDAC3B)],
      );
    } else if (level < 120) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFBA24E5), Color(0xFFFDAC3B)],
      );
    } else if (level < 140) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0A66EC), Color(0xFFBB5CBF), Color(0xFFFFB800)],
      );
    } else if (level < 160) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF152C97), Color(0xFF16B6D2)],
      );
    } else if (level < 180) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD401FF), Color(0xFFDE69FF)],
      );
    } else if (level < 200) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE977FF), Color(0xFF62047F)],
      );
    } else if (level < 220) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE58D41), Color(0xFF99611B)],
      );
    } else if (level < 240) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD04A42), Color(0xFFA01D04)],
      );
    } else if (level < 260) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF90FF77), Color(0xFF00C0E8)],
      );
    } else if (level < 280) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF006A), Color(0xFFC43D3D)],
      );
    } else if (level < 300) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB6A2A2), Color(0xFF62047F)],
      );
    } else if (level < 320) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB6A2A2), Color(0xFFFF00AA)],
      );
    } else if (level < 340) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9AB32D), Color(0xFFE2CC0B)],
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF93806C), Color(0xFFEAA01E)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 60,
      height: 25,
      child: Text(
        "$level",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
      decoration: BoxDecoration(
          gradient: getColor(level), borderRadius: BorderRadius.circular(15)),
    );
  }
}

import 'package:flutter/material.dart';

class BottomNavItem {
  final String path;
  final String name;
  final String title;
  final String icon;
  final Widget page;

  BottomNavItem({
    required this.path,
    required this.name,
    required this.title,
    required this.icon,
    required this.page,
  });
}
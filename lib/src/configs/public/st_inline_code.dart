import 'package:flutter/material.dart';

class StInlineCodeConfig {
  final Color backgroundColor;
  final TextStyle style;
  final EdgeInsetsGeometry padding;
  final double boxRadius;
  const StInlineCodeConfig({
    this.backgroundColor: const Color(0xff333333),
    this.style: const TextStyle(color: Color(0xfff2f2f2)),
    this.padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.boxRadius: 5,
  });
}
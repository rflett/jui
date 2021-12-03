import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double _width;
  final double _height;

  const SkeletonBox(this._width, this._height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ColoredBox(color: Colors.grey),
    );
  }
}

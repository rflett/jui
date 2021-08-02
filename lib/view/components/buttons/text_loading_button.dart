import 'package:flutter/material.dart';

class TextLoadingButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;

  const TextLoadingButton(
      {Key? key,
        required this.child,
        required this.onPressed,
        required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: isLoading
          ? Padding(
          padding: EdgeInsets.all(5),
          child: CircularProgressIndicator.adaptive())
          : child,
      onPressed: isLoading ? null : onPressed,
    );
  }
}
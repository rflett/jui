import 'package:flutter/material.dart';

class OutlinedLoadingButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;

  const OutlinedLoadingButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: isLoading
          ? Padding(
              padding: EdgeInsets.all(5),
              child: CircularProgressIndicator.adaptive())
          : child,
      onPressed: isLoading ? null : onPressed,
    );
  }
}

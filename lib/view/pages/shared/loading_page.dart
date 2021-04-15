import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Lottie.asset(
        "assets/animations/network-animation.json",
        width: 300,
        height: 300,
      ),
    );
  }
}

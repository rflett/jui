import 'package:flutter/material.dart';

class QrWidget extends StatelessWidget {
  final String teamName;
  final String qrUrl;

  const QrWidget({Key? key, required this.teamName, required this.qrUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 280,
        width: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 20,
              children: [
                Text(teamName),
                Image.asset("assets/images/test-qr.png",
                    width: 200, height: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

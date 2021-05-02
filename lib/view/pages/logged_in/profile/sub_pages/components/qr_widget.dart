import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QrWidget extends StatelessWidget {
  final String qrContent;

  const QrWidget({Key? key, required this.qrContent}) : super(key: key);

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
                SizedBox(
                    width: 200,
                    height: 200,
                    child: GestureDetector(
                      child: QrImage(data: this.qrContent),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

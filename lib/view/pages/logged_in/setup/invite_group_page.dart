import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/colors.dart';
import 'package:share/share.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/storage.dart';

class InviteGroupPage extends StatefulWidget {
  @override
  _InviteGroupPageState createState() => _InviteGroupPageState();
}

class _InviteGroupPageState extends State<InviteGroupPage> {
  TextEditingController _groupCodeController =
      new TextEditingController(text: '');
  TextEditingController _groupQRController =
      new TextEditingController(text: '');

  _InviteGroupPageState() {
    this.getData();
  }

  @override
  void dispose() {
    _groupCodeController.dispose();
    _groupQRController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All done!"),
        ),
        body: Center(
            child: Column(children: [
          SizedBox(height: 20),
          ConstrainedBox(
              constraints:
                  BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 600),
              child: Column(
                children: [
                  Text(
                    "Invite your mates to your group by sending them this code or scanning the QR.",
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _groupCodeController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.share_rounded),
                          onPressed: _onSharePressed,
                        ),
                        labelText: "Invite Code",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 40),
                  Visibility(child: qrcode(context), visible: this._groupQRController.text != ""),
                  SizedBox(height: 40),
                  Hero(
                    tag: "go-to-leaderboard",
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                        primary: Colors.white,
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(300, 60),
                      ),
                      child: Text("LET'S GO", style: TextStyle(fontSize: 25)),
                      onPressed: onNextClicked,
                    ),
                  ),
                ],
              ))
        ])));
  }

  @override
  Widget qrcode(BuildContext context) {
    Uint8List bytes = base64.decode(this._groupQRController.text);
    return new Image.memory(bytes);
  }

  void _onSharePressed() {
    var shareUrl =
        "Vote and compete in the Hottest 100 with me on JUI! https://jaypi.online/join/${this._groupCodeController.text}";
    Share.share(shareUrl);
  }

  /// Called when the 'next' button is clicked
  onNextClicked() async {
    Navigator.pushNamedAndRemoveUntil(context, gameRoute, (route) => false);
  }

  getData() async {
    var groupId = await DeviceStorage.retrieveValue(storagePrimaryGroupId);
    await getGroupCode(groupId!);
    await getGroupQR(groupId);
  }

  getGroupCode(String groupId) async {
    try {
      var group = await Group.get(groupId);
      setState(() {
        this._groupCodeController.text = group.code;
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  getGroupQR(String groupId) async {
    try {
      var qr = await Group.getQR(groupId);
      setState(() {
        this._groupQRController.text = qr;
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }
}

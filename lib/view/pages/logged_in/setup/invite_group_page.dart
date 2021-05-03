import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';
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

  _InviteGroupPageState() {
    this.getData();
  }

  @override
  void dispose() {
    _groupCodeController.dispose();
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
                  Visibility(child: QrWidget(qrContent: this._groupCodeController.text), visible: this._groupCodeController.text != "",),
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
}

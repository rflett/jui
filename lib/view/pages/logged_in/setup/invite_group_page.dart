import 'package:flutter/material.dart';
import 'package:jui/utilities/navigation.dart';
import 'package:jui/view/pages/logged_in/components/share_group_code.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';
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
  String _groupCode = "";

  _InviteGroupPageState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All done!"),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 100, maxWidth: 300, maxHeight: 600),
                  child: Column(
                    children: [
                      Text(
                        "Invite your mates to your group by sending them this code or scanning the QR.",
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      ShareGroupCode(code: this._groupCode),
                      SizedBox(height: 40),
                      Visibility(
                        child: QrWidget(qrContent: this._groupCode),
                        visible: this._groupCode != "",
                      ),
                      SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          child: Text("NEXT"),
                          onPressed: onNextClicked,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Called when the 'next' button is clicked
  onNextClicked() async {
    Navigate(context).toGamePage();
  }

  getData() async {
    var groupId = await DeviceStorage.retrieveValue(storagePrimaryGroupId);
    await getGroupCode(groupId!);
  }

  getGroupCode(String groupId) async {
    try {
      var group = await Group.get(groupId);
      setState(() {
        this._groupCode = group.code;
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }
}

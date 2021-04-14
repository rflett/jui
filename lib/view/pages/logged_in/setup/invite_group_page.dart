import 'package:flutter/material.dart';
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
  String _groupQr = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  getData() async {
    var groupId = await DeviceStorage.retrieveValue(storagePrimaryGroupId);

    // get the group invite code
    try {
      var group = await Group.get(groupId!);
      this._groupCode = group.code;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }

    // get the QR code (base64 encoded PNG string)
    try {
      var qr = await Group.getQR(groupId!);
      this._groupQr = qr;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }
}

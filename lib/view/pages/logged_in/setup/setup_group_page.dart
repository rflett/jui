import 'package:flutter/material.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/models/dto/request/group/create_update_group.dart';
import 'package:jui/models/dto/request/group/join_group.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/server/group.dart';

class SetupGroupPage extends StatefulWidget {
  @override
  _SetupGroupPageState createState() => _SetupGroupPageState();
}

class _SetupGroupPageState extends State<SetupGroupPage> {
  String _groupCode = "";
  String _groupName = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get your mates together"),
      ),
      body: Center(
        child: Column(children: [
          ConstrainedBox(
            constraints:
            BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 350),
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        onChanged: (val) => _groupCode = val,
                        validator: validateGroupCode,
                        decoration: InputDecoration(
                            labelText: "Code",
                            border: UnderlineInputBorder()),
                      ),
                      Hero(
                        tag: "scan-qr-button",
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            primary: Colors.white,
                            padding: EdgeInsets.all(15),
                            minimumSize: Size(300, 60),
                          ),
                          child: Text("Scan QR Code", style: TextStyle(fontSize: 25)),
                          onPressed: onScanQRClicked,
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => _groupName = val,
                        validator: validateGroupName,
                        decoration: InputDecoration(
                            labelText: "Name",
                            border: UnderlineInputBorder()),
                      ),
                      Hero(
                        tag: "update-group-button",
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            primary: Colors.white,
                            padding: EdgeInsets.all(15),
                            minimumSize: Size(300, 60),
                          ),
                          child: Text("Next", style: TextStyle(fontSize: 25)),
                          onPressed: onNextClicked,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  onScanQRClicked() {
    // TODO prompt for camera to scan QR
  }

  onNextClicked() async {
    if (_formKey.currentState?.validate() == true) {
      if (this._groupCode != "") {
        // attempt to join the group
        var msg = await this.joinGroup();
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: msg));
          // TODO move on to next page
        }
      } else if (this._groupName != "") {
        // attempt to create the group
        var msg = await this.createGroup();
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: msg));
          // TODO move on to next page
        }
      }
    }
  }

  String? validateGroupCode(String? currentValue) {
    if (currentValue != null) {
      if (!currentValue.contains(RegExp("^[a-zA-Z0-9]{6}\$"))) {
        return "Invalid group code";
      }
    }

    return null;
  }

  String? validateGroupName(String? currentValue) {
    if (currentValue != null) {
      if (currentValue.isEmpty) {
        return "Group name can't be empty";
      }
    }

    return null;
  }

  Future<Text?> joinGroup() async {
    var requestData = JoinGroupRequest(this._groupCode);
    try {
      var group = await Group.join(requestData);
      return Text("Welcome to " + group.name + "!");
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  Future<Text?> createGroup() async {
    var requestData = CreateUpdateGroupRequest(this._groupName);
    try {
      var group = await Group.create(requestData);
      return Text("Welcome to " + group.name + "!");
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }
}

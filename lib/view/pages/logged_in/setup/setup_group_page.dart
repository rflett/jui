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
  TextEditingController _groupCode = new TextEditingController(text: '');
  bool _codeIsValid = false;
  bool _codeValidityVisible = false;
  String _groupName = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _groupCode.dispose();
    super.dispose();
  }

  void checkCodeValidity() {
    this._codeIsValid =
        this._groupCode.text.contains(RegExp("^[a-zA-Z0-9]{6}\$"));
    ;
  }

  void setCodeValidityVisibility(bool visible) {
    setState(() {
      this._codeValidityVisible = visible;
    });
  }

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
                        onChanged: (val) =>
                            this._formKey.currentState!.validate(),
                        controller: _groupCode,
                        validator: validateGroupCode,
                        decoration: InputDecoration(
                          labelText: "Code",
                          border: UnderlineInputBorder(),
                          suffixIcon: Visibility(
                              visible: this._codeValidityVisible,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Icon(
                                  this._codeIsValid == true
                                      ? Icons.check
                                      : Icons.close,
                                  color: this._codeIsValid == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              )),
                        ),
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
                          child: Text("Scan QR Code",
                              style: TextStyle(fontSize: 25)),
                          onPressed: onScanQRClicked,
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => _groupName = val,
                        validator: validateGroupName,
                        decoration: InputDecoration(
                            labelText: "Name", border: UnderlineInputBorder()),
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
    setState(() {
      // TODO scan from the QR, duh
      this._groupCode.text = "abj95I";
      this._formKey.currentState!.validate();
    });
  }

  onNextClicked() async {
    if (_formKey.currentState?.validate() == true) {
      if (this._groupCode.text != "") {
        // attempt to join the group
        // var msg = await this.joinGroup();
        var msg = "Joined!";
        if (msg != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
          // TODO move on to next page
        }
      } else if (this._groupName != "") {
        // attempt to create the group
        // var msg = await this.createGroup();
        var msg = "Created!";
        if (msg != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
          // TODO move on to next page
        }
      }
    }
  }

  bool isCodeValid() {
    return this._groupCode.text.contains(RegExp("^[a-zA-Z0-9]{6}\$"));
  }

  String? validateGroupCode(String? currentValue) {
    if (currentValue == "" && this._groupName == "") {
      this.setCodeValidityVisibility(false);
      return "Either a code or name are required";
    }

    this.checkCodeValidity();

    if (currentValue != "" && this._codeIsValid) {
      // valid
      this.setCodeValidityVisibility(true);
      return null;
    } else if (currentValue != "" && !this._codeIsValid) {
      // invalid
      this.setCodeValidityVisibility(true);
      return "Invalid code";
    } else {
      this.setCodeValidityVisibility(false);
      return null;
    }
  }

  String? validateGroupName(String? currentValue) {
    if (currentValue == "" && this._groupCode.text == "") {
      return "Either a code or name are required";
    }

    if (this._groupCode.text != "" && currentValue != "") {
      // favouring usage of the group code as it's not empty
      return null;
    }

    if (this._groupCode.text == "" && currentValue != "") {
      // TODO more validation of the group name
      return null;
    }

    return null;
  }

  Future<Text?> joinGroup() async {
    var requestData = JoinGroupRequest(this._groupCode.text);
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

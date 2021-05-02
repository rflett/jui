import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:jui/constants/app_routes.dart';
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
  // group code used to join an existing group
  TextEditingController _groupCodeController = new TextEditingController(text: '');
  // whether the current code is a valid code or not
  bool _codeIsValid = false;
  // whether to show the cross/check for code validity
  bool _codeValidityIconIsVisible = false;
  // group name used to create a new group
  String _groupName = "";

  // qr code stuff
  bool scanQrVisible = false;
  Barcode? qrResult;
  QRViewController? qrCodeController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // forms
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _groupCodeController.dispose();
    qrCodeController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrCodeController!.pauseCamera();
    }
    qrCodeController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get your mates together"),
      ),
      body: Center(
        child: Column(children: [
          Visibility(
              visible: scanQrVisible,
              child: Expanded(
                flex: 5,
                child: _buildQrView(context),
              )),
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
                        controller: _groupCodeController,
                        validator: validateGroupCode,
                        decoration: InputDecoration(
                          labelText: "Code",
                          border: UnderlineInputBorder(),
                          suffixIcon: Visibility(
                              visible: this._codeValidityIconIsVisible,
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
                          child: Text("NEXT", style: TextStyle(fontSize: 25)),
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

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrCodeController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrResult = scanData;
        this._groupCodeController.text = qrResult == null ? "" : qrResult!.code;
        this._formKey.currentState!.validate();
        // TODO show some kind of loading spinner
        this.joinGroup();
      });
    });
  }

  /// Called when the scan QR code button is pressed
  onScanQRClicked() {
    setState(() {
      this.scanQrVisible = !scanQrVisible;
    });
  }

  /// Called when the 'next' button is clicked
  onNextClicked() async {
    if (_formKey.currentState?.validate() == true) {
      // favour joining a group over creating a new one if a code is entered
      if (this._groupCodeController.text != "") {
        await this.joinGroup();
      } else if (this._groupName != "") {
        await this.createGroup();
      }
    }
  }

  /// Sets whether the check or cross mark for the group code validity check is visible
  void setCodeValidityVisibility(bool visible) {
    setState(() {
      this._codeValidityIconIsVisible = visible;
    });
  }

  /// Handles form field validation for the group code
  String? validateGroupCode(String? currentValue) {
    if (currentValue == "" && this._groupName == "") {
      this.setCodeValidityVisibility(false);
      return "Either a code or name are required";
    }

    this._codeIsValid =
        this._groupCodeController.text.contains(RegExp("^[a-zA-Z0-9]{6}\$"));

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

  /// Handles form field validation for the group name
  String? validateGroupName(String? currentValue) {
    if (currentValue == "" && this._groupCodeController.text == "") {
      return "Either a code or name are required";
    }

    if (this._groupCodeController.text != "" && currentValue != "") {
      // favouring usage of the group code as it's not empty
      return null;
    }

    if (this._groupCodeController.text == "" && currentValue != "") {
      // TODO more validation of the group name
      return null;
    }

    return null;
  }

  /// join a group
  Future<void> joinGroup() async {
    var requestData = JoinGroupRequest(this._groupCodeController.text);

    try {
      var group = await Group.join(requestData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome to " + group.name + "!")));
      Navigator.pushNamedAndRemoveUntil(context, firstTimeSetupInviteRoute, (route) => false);
    } catch (err) {
      PopupUtils.showError(context, err as ProblemResponse,
          title: "Invalid group code!");
      this._codeIsValid = false;
      this.setCodeValidityVisibility(true);
    }
  }

  /// create a group
  Future<void> createGroup() async {
    var requestData = CreateUpdateGroupRequest(this._groupName);

    try {
      var group = await Group.create(requestData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You've created " + group.name + "!")));
      Navigator.pushNamedAndRemoveUntil(context, firstTimeSetupInviteRoute, (route) => false);
    } catch (err) {
      PopupUtils.showError(context, err as ProblemResponse,
          title: "Can't create group!");
    }
  }
}

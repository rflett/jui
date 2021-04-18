import 'package:flutter/material.dart';
import 'package:jui/view/components/material_autocomplete.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<DropdownMenuItem<String>> _dropdownOptions = [
    DropdownMenuItem<String>(value: "Group a", child: Text("Group a")),
    DropdownMenuItem<String>(value: "Group b", child: Text("Group b")),
    DropdownMenuItem<String>(value: "Group c", child: Text("Group c")),
    DropdownMenuItem<String>(value: "Group d", child: Text("Group d"))
  ];

  String? _selectedTeamName;

  List<String> _memberOptions = [
    "Nancy",
    "Not Nancy",
    "Someone other than Nancy",
    "Ed"
  ];

  void _leaveGroup() {}

  void _showQrCode() {
    if (_selectedTeamName != null) {
      showDialog(
          context: context,
          builder: (context) {
            return QrWidget(teamName: _selectedTeamName!, qrUrl: "Whatever");
          });
    }
  }

  void _shareInviteCode() {}

  void _removeMember() {}

  Iterable<String> _searchMembers(TextEditingValue value) {
    if (value.text.isNotEmpty) {
      return _memberOptions.where((element) =>
          element.toLowerCase().contains(value.text.toLowerCase()));
    }
    return _memberOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(
          Size(300, 400),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _leaveGroup,
                  child: Text("LEAVE GROUP"),
                ),
                SizedBox(width: 20),
                DropdownButton(
                  value: _selectedTeamName,
                  onChanged: (String? newValue) =>
                      setState(() => _selectedTeamName = newValue),
                  items: _dropdownOptions,
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Stack(children: [
                    TextFormField(
                      enabled: false,
                      initialValue: "zCt97h",
                      decoration: InputDecoration(
                        labelText: "Invite Code",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: IconButton(
                          enableFeedback: true,
                          icon: Icon(Icons.share),
                          onPressed: _shareInviteCode,
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(width: 20),
                TextButton(
                  child: Text("SHOW QR"),
                  onPressed: _showQrCode,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MaterialAutocomplete(
                    optionsBuilder: _searchMembers,
                    labelText: "Members",
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  child: Text("REMOVE"),
                  onPressed: _removeMember,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

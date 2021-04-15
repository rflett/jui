import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<DropdownMenuItem<String>> _dropdownOptions = [
    DropdownMenuItem<String>(value: "a", child: Text("Group a")),
    DropdownMenuItem<String>(value: "b", child: Text("Group b")),
    DropdownMenuItem<String>(value: "c", child: Text("Group c")),
    DropdownMenuItem<String>(value: "d", child: Text("Group d"))
  ];

  List<String> _memberOptions = [
    "Nancy",
    "Not Nancy",
    "Someone other than Nancy",
    "Ed"
  ];

  void _leaveGroup() {}

  void _showQrCode() {}

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
                  value: _dropdownOptions[0].value,
                  onChanged: (String? newValue) => print(newValue),
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
                  child: Text("UPDATE"),
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
                  child: Autocomplete(
                    fieldViewBuilder: ((BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) =>
                        TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                          decoration: InputDecoration(
                            labelText: "Members",
                            border: OutlineInputBorder(),
                          ),
                        )),
                    optionsBuilder: _searchMembers,
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

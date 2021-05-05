import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareGroupCode extends StatelessWidget {
  final String code;

  const ShareGroupCode({Key? key, required this.code}) : super(key: key);

  /// called when the share invite code button is pressed
  void _onShare() {
    var shareUrl =
        "Vote and compete in the Hottest 100 with me on JUI! https://jaypi.online/join/${this.code}";
    Share.share(shareUrl);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = this.code,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.share_rounded),
          onPressed: _onShare,
        ),
        labelText: "Invite Code",
        isDense: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String? uuid;

  const UserAvatar({Key? key, required this.uuid, this.size = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).canvasColor,
      radius: size / 2,
      foregroundImage: uuid != null
          ? NetworkImage(
              "https://www.thispersondoesnotexist.com/image?value=$uuid")
          : null,
      backgroundImage: AssetImage("assets/images/user-regular.png"),
    );
  }
}

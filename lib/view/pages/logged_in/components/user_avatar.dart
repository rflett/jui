import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String uuid;

  const UserAvatar(
      {Key? key, required this.uuid, this.size = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 0.1)],
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            "https://www.thispersondoesnotexist.com/image?value=$uuid",
          ),
        ),
      ),
    );
  }
}

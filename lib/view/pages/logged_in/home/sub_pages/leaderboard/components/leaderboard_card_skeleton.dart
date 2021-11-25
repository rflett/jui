import 'package:flutter/material.dart';
import 'package:jui/view/components/skeleton/skeleton_box.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardCardSkeleton extends StatelessWidget {
  const LeaderboardCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.blueGrey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(uuid: null, size: 80),
                      SizedBox(width: 10),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: SkeletonBox(20, 20),
                          subtitle: SkeletonBox(20, 10),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ListTile(
                            title: SkeletonBox(20, 20),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

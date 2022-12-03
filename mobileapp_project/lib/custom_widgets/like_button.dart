import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class ApproveButton extends StatelessWidget {
  const ApproveButton(
      {super.key, required this.approve, required this.markerID});

  final bool? approve;
  final String markerID;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    // final auth = Provider.of<AuthBase>(context, listen: false);
    if (approve != null) {
      return LikeButton(
        size: 30,
        circleColor:
            const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
        bubblesColor: const BubblesColor(
          dotPrimaryColor: Color(0xff33b5e5),
          dotSecondaryColor: Color(0xff0099cc),
        ),
        isLiked: approve,
        likeBuilder: (isLiked) {
          if (approve != null) {
            db.thumbUpMarker(markerID);
            return Icon(
              Icons.thumb_up,
              color: isLiked ? Colors.blue.withOpacity(0.7) : Colors.grey,
              size: 30,
            );
          }
        },
      );
    } else {
      // Marker information is loading or fails the return a progress indicator
      return const SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(),
      );
    }
  }
}

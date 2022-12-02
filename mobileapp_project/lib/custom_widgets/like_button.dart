import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class ApproveButton extends StatelessWidget {

  const ApproveButton({super.key, required this.approve});

  final bool? approve;


  @override
  Widget build(BuildContext context) {
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
          height: 15, width: 15,
          child: CircularProgressIndicator(),);
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class like_button extends StatelessWidget {
  const like_button({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 30,
      circleColor:
      const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.pink : Colors.grey,
          size: 30,
        );
      },
    );
  }
}
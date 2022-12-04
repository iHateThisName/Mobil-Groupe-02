import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class ApproveButton extends StatefulWidget {
  const ApproveButton(
      {super.key, required this.approve, required this.markerID});

  final bool? approve;
  final String markerID;

  @override
  State<ApproveButton> createState() => _ApproveButtonState();
}

class _ApproveButtonState extends State<ApproveButton> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    return FutureBuilder(
      future: db.isMarkerThumbsUp(widget.markerID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        }

        if (snapshot.hasError) {
          return const Text("💩 Error");
        }

        else {

          return LikeButton(
            size: 30,
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            isLiked: snapshot.data as bool,
            likeBuilder: (isLiked) {

              return IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: isLiked ? Colors.blue.withOpacity(0.7) : Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  bool oldValue = snapshot.data as bool;
                  db.updateThumbsUpValue(widget.markerID, !oldValue);
                  db.updateScore(!oldValue ? 1 : -1);
                  setState(() {});
                },

              );
            },
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

/// Class that represents a custom widget of an elevated button
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton( {
    required this.child,
    required this.color,
    required this.borderRadius,
    this.onPressed,
    });

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback? onPressed;

  /// Builds the elevated button widget
  /// [context] the context
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        child: child
    );
  }

}
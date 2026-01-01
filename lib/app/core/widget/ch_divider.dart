import 'package:flutter/material.dart';

class ChDivider extends StatelessWidget {
  final Color dividerColor;
  final double thickNess;

  const ChDivider({
    super.key,
    this.dividerColor = const Color.fromRGBO(57, 57, 57, 0.2),
    this.thickNess = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Divider(
          color: dividerColor,
          thickness: thickNess,
          height: 1,
          endIndent: 0.0,
          indent: 0.0,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class AvatarWidget extends StatelessWidget {
  final String image;
  final bool isSelected;

  const AvatarWidget({
    super.key,
    required this.image,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? mainClr : Colors.black12, // Hid
          width: isSelected ? 2 : 0,
        ),
      ),
      child: Stack(
        children: [
          if (isSelected)
            Positioned(
              right: 0,
              child: Icon(Icons.check_box_rounded, color: mainClr),
            ),
          Image.asset(image),
        ],
      ),
    );
  }
}

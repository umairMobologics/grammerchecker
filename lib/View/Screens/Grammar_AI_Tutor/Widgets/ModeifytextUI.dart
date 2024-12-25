import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';
import 'package:grammar_checker_app_updated/core/utils/responsiveness.dart';

class MarkDownText extends StatelessWidget {
  final String message;
  const MarkDownText({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      padding: EdgeInsets.all(0),
      data: message,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 24),
        h2: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 22),
        h3: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 20),
        p: TextStyle(color: Colors.white, fontSize: 16.h),
        listBullet: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

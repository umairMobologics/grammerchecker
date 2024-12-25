import 'package:flutter/material.dart';
import 'package:grammar_checker_app_updated/main.dart';

class tutorAnimationImage extends StatefulWidget {
  final double? height;

  const tutorAnimationImage({super.key, this.height});
  @override
  _tutorAnimationImageState createState() => _tutorAnimationImageState();
}

class _tutorAnimationImageState extends State<tutorAnimationImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation in reverse

    // Define the animation, in this case, scaling the icon from 1x to 1.2x
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose the controller when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: (mq.height * 0.005),
              left: (mq.height * 0.005),
            ),
            child: Image.asset(
              "assets/tutor.png",
              height: widget.height ?? mq.height * 0.08,
            ),
          ),
        );
      },
    );
  }
}

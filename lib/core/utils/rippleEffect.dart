import 'package:flutter/material.dart';

///
/// Wrapper around the InkWell.
/// Handles taps with ripple effect.
///
class RippleEffect extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? rippleColor;

  const RippleEffect({
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.rippleColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(0)),
      child: Material(
        elevation: 10,
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          splashColor: rippleColor ?? Theme.of(context).primaryColorLight,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
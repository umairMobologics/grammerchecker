import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RewardContainer extends StatelessWidget {
  const RewardContainer({
    super.key,
    required this.mq,
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconText,
    required this.textClr,
    required this.onTap,
  });

  final Size mq;
  final String? svgAsset;
  final String title;
  final String description;
  final Widget icon;
  final Widget iconText;
  final Color textClr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (svgAsset != null) SvgPicture.asset(svgAsset!),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: textClr,
                                fontSize: mq.height * 0.035,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              color: textClr,
                              fontSize: mq.height * 0.016,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: icon,
                  )
                ],
              ),
              SizedBox(height: mq.height * 0.003),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: iconText,
              )
            ],
          ),
        ],
      ),
    );
  }
}

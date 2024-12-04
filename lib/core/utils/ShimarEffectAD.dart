import 'package:flutter/material.dart';
import 'package:grammer_checker_app/core/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmarrNativeSmall extends StatelessWidget {
  final Size mq;
  final double height;
  const ShimmarrNativeSmall(
      {super.key, required this.mq, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.grey),
      ),
      height: height,
      width: mq.width * 1,
      child: Row(
        children: [
          SizedBox(
            width: mq.width * .05,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading Ad"),
              SizedBox(
                width: mq.width * .22,
                height: 75.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Rectangle placeholder
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 10.0), // Add spacing between elements
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: mq.width * .6,
                height: 20.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300], // Rectangle placeholder
                  ),
                ),
              ),
              const SizedBox(height: 5.0), // Add spacing between shimmer lines
              SizedBox(
                width: mq.width * .4,
                height: 20.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300], // Rectangle placeholder
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: mq.width * .65,
                height: 15.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300], // Rectangle placeholder
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: mq.width * .66,
                height: 35.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300], // Rectangle placeholder
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmarrNativeLarge extends StatelessWidget {
  final Size mq;
  final double height;
  const ShimmarrNativeLarge(
      {super.key, required this.mq, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.grey),
      ),
      height: height,
      width: mq.width * 1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Rectangle placeholder
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Row(
              children: [
                SizedBox(
                  width: mq.width * .05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading Ad"),
                    SizedBox(
                      width: mq.width * .22,
                      height: 75.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Rectangle placeholder
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10.0), // Add spacing between elements
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: mq.width * .6,
                      height: 20.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey[300], // Rectangle placeholder
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 5.0), // Add spacing between shimmer lines
                    SizedBox(
                      width: mq.width * .4,
                      height: 20.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey[300], // Rectangle placeholder
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: mq.width * .65,
                      height: 15.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey[300], // Rectangle placeholder
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: mq.width * .66,
                      height: 35.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300], // Rectangle placeholder
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmarrEffectBanner extends StatelessWidget {
  final Size mq;
  final double height;
  const ShimmarrEffectBanner(
      {super.key, required this.mq, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Colors.grey),
      ),
      height: height,
      width: mq.width * 1,
      child: Row(
        children: [
          SizedBox(
            width: mq.width * .05,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading Ad"),
            ],
          ),

          const SizedBox(width: 10.0), // Add spacing between elements
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: mq.width * .6,
                height: 15.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300], // Rectangle placeholder
                  ),
                ),
              ),
              const SizedBox(height: 5.0), // Add spacing between shimmer lines
              SizedBox(
                width: mq.width * .4,
                height: 15.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300], // Rectangle placeholder
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//shimmar effect RewardCenter
class ShimmerEffectReward extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ShimmerEffectReward({
    Key? key,
    required this.height,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grammar_checker_app_updated/core/utils/colors.dart';

class ProFeatureDialog extends StatelessWidget {
  final VoidCallback onWatchAdTap;
  final VoidCallback onGetProTap;

  const ProFeatureDialog({
    Key? key,
    required this.onWatchAdTap,
    required this.onGetProTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "This is a PRO feature!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Watch a quick ad to get clue, or get Grammar PRO.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: onGetProTap,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "GO PRO 👑",
                      style: TextStyle(fontSize: 14, color: black),
                    )),
                ElevatedButton(
                  onPressed: onWatchAdTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainClr,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    "Watch an ad",
                    style: TextStyle(color: white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';

class LevelIntroDialog {
  static void showLevel1Dialouge(BuildContext context, VoidCallback onTap) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing without action
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Welcome to Level 1!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here's how the game works:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. You will encounter 20 questions with shuffled characters. \n"
                "2. Your goal is to arrange the characters to form the correct word.\n"
                "3. Each correct answer earns 5 points. Score more than 70 out of 100 to win the level.\n"
                "4. If you need help, use the Clue button to reveal the next character. Watching a short ad will unlock the clue.\n"
                "5. If you win, you’ll receive 5 extra credits and unlock Level 2.\n"
                "6. If you lose, don’t worry! You can try again until you win.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Pro Tip: Pay attention to the shuffled characters and think quickly to maximize your score!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Good luck, and have fun!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: mainClr),
                child: Text(
                  "Got it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //level 2 dialouge
  static void showLevel2Dialouge(BuildContext context, VoidCallback onTap) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing without action
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Welcome to Level 2!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here's how the game works:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. You will encounter 20 questions with shuffled words.\n"
                "2. Your goal is to arrange the words to form the correct sentence.\n"
                "3. Each correct answer earns 5 points. Score more than 70 out of 100 to win the level.\n"
                "4. If you need help, use the Clue button to reveal the next word. Watching a short ad will unlock the clue.\n"
                "5. If you win, you’ll receive 10 extra credits and unlock Level 3.\n"
                "6. If you lose, don’t worry! You can try again until you win.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Pro Tip: Focus on the structure of the sentence. Think about subject-verb agreement and word order!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Good luck, and enjoy Level 2!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: mainClr),
                child: Text(
                  "Got it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //level 3 dialouge
  static void showLevel3Dialouge(BuildContext context, VoidCallback onTap) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing without action
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Welcome to Level 3!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here's how the game works:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. You will encounter 20 questions with fill-in-the-blank sentences.\n"
                "2. Your goal is to select the correct option to complete the sentence.\n"
                "3. Each correct answer earns 5 points. Score more than 70 out of 100 to win the level.\n"
                "4. If you need help, use the Clue button to reveal the next correct option. Watching a short ad will unlock the clue.\n"
                "5. If you win, you’ll receive 15 extra credits and complete the final level.\n"
                "6. If you lose, don’t worry! You can try again until you win.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Pro Tip: Read the sentence carefully and analyze the context to select the correct option!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Good luck, and enjoy Level 3!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: mainClr),
                child: Text(
                  "Got it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

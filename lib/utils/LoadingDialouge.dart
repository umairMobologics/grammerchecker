  import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showLoadingDialog(BuildContext context, Size mq) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed manually
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Prevents the back button from closing the dialog
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(height: mq.height*0.12,
            // color: red,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                Lottie.asset("assets/l.json",height: mq.height*0.08),
              
                  Text("Please wait...", style: TextStyle(fontSize: mq.height*0.020,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
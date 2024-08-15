import 'package:flutter/material.dart';
import 'package:grammer_checker_app/utils/colors.dart';
import 'package:lottie/lottie.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/noInternet.json", height: 200),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Text(
            textAlign: TextAlign.center,
            "Internet connection Lost!",
            style: TextStyle(
                fontSize: size.height * 0.020,
                fontWeight: FontWeight.w500,
                color: black54),
          ),
        ),
      ],
    ));
  }
}

void showNoInternetDialog(BuildContext context, Size size) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // maxWidth: size.width * 0.8, // Adjust the width as needed
            maxHeight: size.height * 0.8, // Adjust the height as needed
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NoInternetWidget(size: size),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60), color: mainClr),
                  child: Center(
                    child: Text(
                      "Got It",
                      style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';

class SubscriptionInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Info'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BulletPoint(
                text:
                    'Subscribed users have unlimited access to all the features inside the app and can enjoy our continually updated content.'),
            BulletPoint(
                text:
                    'You can manage your subscriptions in the Play Store subscription setting after purchase.'),
            BulletPoint(
                text:
                    'For YEARLY/MONTHLY SUBSCRIPTION users, the subscription will automatically renew unless it is turned off at least 24 hours before the end of the current period.'),
            BulletPoint(text: 'ONE-TIME payment cannot be reverted.'),
            BulletPoint(
                text:
                    'Once the subscription period is over, auto-renewal will take place.'),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('👉 ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }
}

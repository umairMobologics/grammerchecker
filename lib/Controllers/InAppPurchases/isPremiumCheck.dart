import '../../main.dart';

bool ispremium() {
  return (!(Subscriptioncontroller.isMonthlypurchased.value ||
      Subscriptioncontroller.isWeeklypurchased.value ||
      Subscriptioncontroller.isYearlypurchased.value));
}

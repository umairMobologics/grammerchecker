import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';

import '../PremiumFeatureController.dart';

class InAppPurchaseController extends GetxController {
  final premiumC = Get.put(PremiumFeatureController());

  /*Note:    before testing: 
  *you add your gmail  as a testing account is develepor account
  *after that make sure that you add that gmail account to your playstore app on a testing device
  * remove all other playstore accounts only that account should be login which is added as a testing account to your develepor account
  * if you want to test on another project you only need product IDS and a app package name which is regester on that acoount
  *replace your current app package name with that and you are ready to test on other projects as well

   */
  RxBool isYearlypurchased = false.obs;
  RxBool isMonthlypurchased = false.obs;
  static final Logger _log = Logger('InAppPurchases');

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  late InAppPurchase inAppPurchaseInstance;
  final Set<String> _inAppPurchaseId = {
    "grammarchecker_monthly",
    'grammarchecker_yearly'
  }; //your subscription plan products IDs from playstore account
  // final String productIdForLifeTime = 'appsonix_adsfree_speakandtranslate';
  RxString data = "".obs;
  RxBool isloaded = false.obs;
  InAppPurchaseController(this.inAppPurchaseInstance);
  var productDetailsList = <ProductDetails>[].obs;

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> getData() async {
    log("getting data *********");
    isloaded.value = true;
    final response =
        await inAppPurchaseInstance.queryProductDetails(_inAppPurchaseId);

    if (response.productDetails.isNotEmpty) {
      productDetailsList.clear(); // Clear the previous list
      for (var product in response.productDetails) {
        productDetailsList.add(product);
        premiumC.changeSelectedPlan(productDetailsList[0].id);
        log("initial plan selected **** ${selectedPlan.value}");
      }
    } else {
      data.value = "No Plan Found!";
    }
    isloaded.value = false;
  }

  Future<void> buy(String inAppPurchaseId) async {
    if (!await inAppPurchaseInstance.isAvailable()) {
      _reportError('InAppPurchase.instance not available');
      return;
    }

    log('Querying the store with queryProductDetails()');
    final response =
        await inAppPurchaseInstance.queryProductDetails({inAppPurchaseId});
    if (response.error != null) {
      _reportError(
          'There was an error when making the purchase: ${response.error}');
      return;
    }
    if (response.productDetails.length != 1) {
      _reportError(
          'There was an error when making the purchase: product $inAppPurchaseId does not exist?');
      return;
    }
    final productDetails = response.productDetails.single;

    log('Making the purchase');
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    try {
      final success = await inAppPurchaseInstance.buyNonConsumable(
          purchaseParam: purchaseParam);
      log('buyNonConsumable() request was sent with success: $success');
    } catch (e) {
      _log.severe(
          'Problem with calling inAppPurchaseInstance.buyNonConsumable(): $e');
    }
  }

  Future<void> restorePurchases() async {
    if (!await inAppPurchaseInstance.isAvailable()) {
      _reportError('InAppPurchase.instance not available');
      return;
    }

    try {
      await inAppPurchaseInstance.restorePurchases();
      log('In-app purchases restored called');
    } catch (e) {
      _log.severe('Could not restore in-app purchases: $e');
    }
  }

  void initialize() {
    log("init....");
    _subscription?.cancel();
    _subscription = inAppPurchaseInstance.purchaseStream.listen(
      (purchaseDetailsList) {
        log("going...");
        listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (dynamic error) {
        _log.severe('Error occurred on the purchaseStream: $error');
      },
    );
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (!_inAppPurchaseId.contains(purchaseDetails.productID)) {
        _log.severe(
            "The handling of the product with id '${purchaseDetails.productID}' is not implemented.");

        continue;
      }

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:

          //here purchaseDetails.productID == "monthlysubst" is used just to check only one product status
          if (purchaseDetails.productID == "grammarchecker_monthly") {
            if (purchaseDetails.status == PurchaseStatus.purchased ||
                purchaseDetails.status == PurchaseStatus.restored) {
              isMonthlypurchased.value = true;
              log('Subscribed to Monthly offer ${purchaseDetails.productID}');
            }
          } else if (purchaseDetails.productID == "grammarchecker_yearly") {
            if (purchaseDetails.status == PurchaseStatus.purchased ||
                purchaseDetails.status == PurchaseStatus.restored) {
              isYearlypurchased.value = true;
              log('Subscribed to yearly offer ${purchaseDetails.productID}');
            }
          }
          break;
        case PurchaseStatus.error:
          _log.severe('Error with purchase: ${purchaseDetails.error}');

          break;
        case PurchaseStatus.canceled:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchaseInstance.completePurchase(purchaseDetails);
      }
    }
  }

  void _reportError(String message) {
    _log.severe(message);
    log(message);
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:grammer_checker_app/View/Screens/BottomNav/BottomNavScreen.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var currentPage = 0.obs;

  RxBool checkConnectivityResult = false.obs;
  final listUpdate = Get.put(BottomNavBarScreen());

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    // Check if there is any active connectivity
    bool hasConnection =
        connectivityResults.any((result) => result != ConnectivityResult.none);
    checkConnectivityResult.value = !hasConnection;
  }
}

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}

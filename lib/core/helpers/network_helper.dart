import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';

class NetworkHelper {
  static bool _initialized = false;
  static bool _hasInternet = true;
  static bool _checkingInternet = false;

  static DateTime? _lastToastTime;
  static String? _lastErrorKey;

  static final Connectivity _connectivity = Connectivity();
  static late final Stream<List<ConnectivityResult>> _connectivityStream;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _connectivityStream = _connectivity.onConnectivityChanged;

    _hasInternet = await _checkInternet();
    if (!_hasInternet) {
      _showToast(
        title: "No Internet",
        message: "Please check your internet connection",
        errorKey: "NO_INTERNET",
        force: true,
      );
    }

    _connectivityStream.listen((_) async {
      final currentStatus = await _checkInternet();
      _hasInternet = currentStatus;

      if (!_hasInternet) {
        _showToast(
          title: "No Internet",
          message: "Please check your internet connection",
          errorKey: "NO_INTERNET",
          force: true,
        );
      }
    });
  }

  static void showError(String message, {String? errorKey}) {
    _showToast(title: "Error", message: message, errorKey: errorKey ?? message);
  }

  static void _showToast({
    required String title,
    required String message,
    required String errorKey,
    bool force = false,
  }) {
    if (!force && !_canShowToast(errorKey)) return;

    _lastToastTime = DateTime.now();
    _lastErrorKey = errorKey;

    Fluttertoast.showToast(
      msg: "$title: $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.error,
      textColor: AppColors.surface,
      fontSize: 14,
    );
  }

  static bool _canShowToast(String errorKey) {
    if (_lastToastTime == null) return true;

    final diff = DateTime.now().difference(_lastToastTime!);

    if (_lastErrorKey == "TIMEOUT" || _lastErrorKey == "NO_INTERNET") {
      return diff.inSeconds >= 8;
    }

    if (_lastErrorKey == errorKey && diff.inSeconds < 8) {
      return false;
    }

    return true;
  }


  static Future<bool> hasInternet() async {
    if (!_hasInternet) {
      _hasInternet = await _checkInternet();
    }
    return _hasInternet;
  }

  static Future<bool> _checkInternet() async {
    if (_checkingInternet) return _hasInternet;

    _checkingInternet = true;
    bool hasInternet = false;

    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        final result = await InternetAddress.lookup("google.com");
        hasInternet = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      }
    } catch (_) {
      hasInternet = false;
    }

    _checkingInternet = false;
    return hasInternet;
  }
}

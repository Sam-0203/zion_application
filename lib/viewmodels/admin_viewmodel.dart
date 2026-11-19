import 'package:get/get.dart';

import 'package:flutter_app/core/utils/minimum_loader_duration.dart';
import 'package:flutter_app/models/user/admin_responses_model.dart';
import 'package:flutter_app/services/admin_services.dart';

class AdminLoginViewModel extends GetxController {
  final AdminLoginService _service = AdminLoginService();

  bool isLoading = false;
  String? errorMessage;
  AdminLoginResponse? loginResponse;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final startedAt = DateTime.now();
    isLoading = true;
    errorMessage = null;
    update();

    try {
      loginResponse = await _service.adminLogin(
        username: username,
        password: password,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isLoading = false;
      update();
    }
  }
}

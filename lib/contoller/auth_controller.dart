import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_task_management/services/auth_service.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rxn<User> currentUser = Rxn<User>();
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  void _checkAuthState() {
    _authService.authStateChanges.listen((user) {
      currentUser.value = user;
      isLoggedIn.value = user != null;

      if (user != null) {
        _storage.write('user_id', user.uid);
        _storage.write('user_email', user.email);
        _storage.write('user_name', user.displayName);
        _storage.write('is_logged_in', true);
      } else {
        _storage.erase(); 
      }

      print("Auth state changed: ${user?.uid ?? 'logged out'}");
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.login(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      isLoading.value = true;
      await _authService.register(email, password, name);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _storage.erase();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    }
  }
}

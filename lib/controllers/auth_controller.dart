import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_con/models/user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // Base URL getter with platform checks
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }

    try {
      if (Platform.isIOS) {
        return 'http://127.0.0.1:8000/api';
      }
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';
      }
    } catch (e) {
      print('Platform check error: $e');
    }

    return 'http://localhost:8000/api';
  }

  @override
  void onInit() {
    super.onInit();
    ever(currentUser, handleAuthStateChange);
    checkAuthStatus();
  }

  void handleAuthStateChange(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/dashboard');
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userData = prefs.getString('user');

      if (token != null && userData != null) {
        try {
          final user = User.fromJson(
            json.decode(userData),
            token: token,
          );

          // Verify token validity
          final response = await http
              .get(
                Uri.parse('$baseUrl/user'),
                headers: getHeaders(token),
              )
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            currentUser.value = user;
          } else {
            await logout(showMessage: false);
          }
        } catch (e) {
          print('Token verification error: $e');
          await logout(showMessage: false);
        }
      }
    } catch (e) {
      print('Auth status check error: $e');
      await logout(showMessage: false);
    }
  }

  Map<String, String> getHeaders([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Login attempt for: $email to $baseUrl/login');

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: getHeaders(),
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Login response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user'], token: data['token']);

        // Save user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);
        await prefs.setString('user', json.encode(user.toJson()));

        currentUser.value = user;
        showSuccess('Login successful!');
        return true;
      } else {
        handleErrorResponse(response);
        return false;
      }
    } catch (e) {
      handleError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Registration attempt for: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: getHeaders(),
            body: json.encode({
              'name': username,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Register response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        showSuccess('Registration successful! Please login.');
        await Get.offAllNamed('/login');
        return true;
      } else {
        handleErrorResponse(response);
        return false;
      }
    } catch (e) {
      handleError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout({bool showMessage = true}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        try {
          await http
              .post(
                Uri.parse('$baseUrl/logout'),
                headers: getHeaders(token),
              )
              .timeout(const Duration(seconds: 5));
        } catch (e) {
          print('Logout API error: $e');
        }
      }

      await _clearLocalData();
      currentUser.value = null;

      if (showMessage) {
        showSuccess('Logged out successfully');
      }

      return true;
    } catch (e) {
      print('Logout error: $e');
      await _clearLocalData();
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Clear local data error: $e');
    }
  }

  void handleErrorResponse(http.Response response) {
    try {
      final data = json.decode(response.body);
      errorMessage.value = data['message'] ?? 'An error occurred';
      showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An error occurred';
      showError('An error occurred');
    }
  }

  void handleError(dynamic error) {
    String message = 'An error occurred';

    if (error is SocketException) {
      message =
          'Could not connect to server. Please check your internet connection.';
    } else if (error is TimeoutException) {
      message = 'Connection timed out. Please try again.';
    } else {
      message = 'Error: ${error.toString()}';
    }

    errorMessage.value = message;
    showError(message);
  }

  void showError(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    );
  }

  void showSuccess(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    );
  }

  // Helper methods
  bool get isLoggedIn => currentUser.value != null;
  String? get currentToken => currentUser.value?.token;
  User? get user => currentUser.value;
}

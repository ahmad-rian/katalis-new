import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_con/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final Rxn<User> user = Rxn<User>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

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
    loadUserProfile();
  }

  Map<String, String> getHeaders([String? token]) {
    if (token == null) {
      return {
        'Accept': 'application/json',
      };
    }
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  String getFullImageUrl(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) {
      return '$baseUrl/images/default-profile.png';
    }
    if (avatarPath.startsWith('http')) return avatarPath;
    return '${baseUrl.replaceAll('/api', '')}/storage/$avatarPath';
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        await Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: getHeaders(token),
      );

      print('Profile Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle both direct user data and nested user data
        final userData = data['user'] ?? data;

        if (userData['avatar'] != null) {
          userData['avatar'] = getFullImageUrl(userData['avatar']);
        }

        user.value = User.fromJson(userData, token: token);
      } else {
        print('Failed to load profile: ${response.body}');
        showError('Failed to load profile');
      }
    } catch (e, stackTrace) {
      print('Error loading profile: $e\n$stackTrace');
      showError('An error occurred while loading profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({String? name, File? avatarFile}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = user.value;
      if (currentUser == null) return false;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/update'),
      );

      // Add headers
      request.headers.addAll(getHeaders(currentUser.token));

      // Add name if provided
      if (name != null && name.isNotEmpty) {
        request.fields['name'] = name;
      }

      // Add avatar if provided
      if (avatarFile != null) {
        final fileName = avatarFile.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            avatarFile.path,
            contentType: MediaType('image', extension),
            filename: fileName,
          ),
        );
      }

      print('Sending update request to: ${request.url}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Update response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userData = data['user'];

        if (userData != null) {
          if (userData['avatar'] != null) {
            userData['avatar'] = getFullImageUrl(userData['avatar']);
          }
          user.value = User.fromJson(userData, token: currentUser.token);
          showSuccess('Profile updated successfully');
          return true;
        }
      }

      final errorData = json.decode(response.body);
      showError(errorData['message'] ?? 'Failed to update profile');
      return false;
    } catch (e, stackTrace) {
      print('Error updating profile: $e\n$stackTrace');
      showError('An error occurred while updating profile');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = user.value;
      if (currentUser == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/profile/change-password'),
        headers: {
          ...getHeaders(currentUser.token),
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        showSuccess('Password changed successfully');
        return true;
      }

      final data = json.decode(response.body);
      showError(data['message'] ?? 'Failed to change password');
      return false;
    } catch (e) {
      print('Error changing password: $e');
      showError('An error occurred while changing password');
      return false;
    } finally {
      isLoading.value = false;
    }
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
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
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
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final currentUser = user.value;

      if (currentUser != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer ${currentUser.token}',
            'Accept': 'application/json',
          },
        );

        print('Logout response: ${response.body}');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset controller state
      user.value = null;
      errorMessage.value = '';

      await Get.offAllNamed('/login');
    } catch (e, stackTrace) {
      print('Error during logout: $e\n$stackTrace');
      showError('An error occurred while logging out');
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../models/member_model.dart';

class MemberController extends GetxController {
  // Service constants
  final String baseUrl = 'http://127.0.0.1:8000/api';
  final storage = GetStorage();

  // Controller variables
  final textEditingController = TextEditingController();
  RxList<Member> members = <Member>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  // Headers for API requests
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // Fetch all members
  Future<void> fetchMembers() async {
    try {
      isLoading(true);
      errorMessage('');

      final headers = await _getHeaders();
      print('Requesting members with headers: $headers');

      final response = await http
          .get(
            Uri.parse('$baseUrl/members'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          members.value = data.map((json) => Member.fromJson(json)).toList();
          print('Members fetched: ${members.length}');
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      print('Error fetching members: $e');
      errorMessage(e.toString());
      // Check if error is due to unauthorized access
      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('401')) {
        print('Unauthorized access detected, redirecting to login');
        await Get.offAllNamed('/login');
      }
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Search members
  Future<void> searchMembers(String query) async {
    if (query.isEmpty) {
      return fetchMembers();
    }

    try {
      isLoading(true);
      errorMessage('');

      final headers = await _getHeaders();

      final response = await http
          .get(
            Uri.parse('$baseUrl/members/search?query=$query'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          members.value = data.map((json) => Member.fromJson(json)).toList();
          print('Search results: ${members.length}');
        } else {
          throw Exception('Invalid search response format');
        }
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      print('Error searching members: $e');
      errorMessage(e.toString());
      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('401')) {
        print('Unauthorized access detected, redirecting to login');
        await Get.offAllNamed('/login');
      }
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}

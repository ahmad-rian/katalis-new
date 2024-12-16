import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event_model.dart';

class EventController extends GetxController {
  // For iOS Simulator or Web
  final String baseUrl = 'http://127.0.0.1:8000/api/events';

  final RxList<Event> kegiatanEvents = <Event>[].obs;
  final RxList<Event> lombaBeasiswaEvents = <Event>[].obs;
  final RxBool isLoadingKegiatan = false.obs;
  final RxBool isLoadingLombaBeasiswa = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKegiatanEvents();
    fetchLombaBeasiswaEvents();
  }

  Future<void> fetchKegiatanEvents() async {
    try {
      isLoadingKegiatan(true);
      error('');

      print('Fetching kegiatan events from: $baseUrl/kegiatan');
      final response = await http.get(
        Uri.parse('$baseUrl/kegiatan'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Kegiatan Response status: ${response.statusCode}');
      print('Kegiatan Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          kegiatanEvents.value =
              data.map((json) => Event.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      print('Error fetching kegiatan events: $e');
    } finally {
      isLoadingKegiatan(false);
    }
  }

  Future<void> fetchLombaBeasiswaEvents() async {
    try {
      isLoadingLombaBeasiswa(true);
      error('');

      print('Fetching lomba-beasiswa events from: $baseUrl/lomba-beasiswa');
      final response = await http.get(
        Uri.parse('$baseUrl/lomba-beasiswa'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Lomba-Beasiswa Response status: ${response.statusCode}');
      print('Lomba-Beasiswa Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          lombaBeasiswaEvents.value =
              data.map((json) => Event.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      print('Error fetching lomba/beasiswa events: $e');
    } finally {
      isLoadingLombaBeasiswa(false);
    }
  }
}

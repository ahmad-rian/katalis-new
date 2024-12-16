import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_con/controllers/event_controller.dart';
import 'package:intl/intl.dart';

class EventScreen extends GetView<EventController> {
  EventScreen({Key? key}) : super(key: key);

  final controller = Get.put(EventController());
  final currentIndex = 0.obs;

  final mainBlue = const Color(0xFF2563EB);
  final lightBlue = const Color(0xFFEEF2FF);
  final mediumBlue = const Color(0xFF60A5FA);
  final darkBlue = const Color(0xFF1E40AF);
  final surfaceGrey = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surfaceGrey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: mainBlue.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: mainBlue.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() => Row(
                  children: [
                    _buildSegmentButton('Info Kegiatan', 0, Icons.event_note),
                    _buildSegmentButton(
                        'Lomba & Beasiswa', 1, Icons.emoji_events),
                  ],
                )),
          ),
          Expanded(
            child: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  ),
                  child: currentIndex.value == 0
                      ? _buildKegiatanList()
                      : _buildLombaBeasiswaList(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, int index, IconData icon) {
    final isSelected = currentIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => currentIndex.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? mainBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: mainBlue.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : mainBlue.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : mainBlue.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event, bool showType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: lightBlue),
        boxShadow: [
          BoxShadow(
            color: mainBlue.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.imageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                children: [
                  Image.network(
                    event.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 200,
                      color: lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              color: mainBlue.withOpacity(0.3), size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(
                              color: mainBlue.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showType)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: mainBlue.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: mainBlue.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          event.jenis == 'Info Lomba'
                              ? Icons.emoji_events
                              : Icons.school,
                          size: 16,
                          color: mainBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          event.jenis == 'Info Lomba' ? 'Lomba' : 'Beasiswa',
                          style: TextStyle(
                            color: mainBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  event.namaEvent,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  event.deskripsi,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.6,
                    fontSize: 15,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 16, color: mainBlue.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      'Posted: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(event.createdAt))}',
                      style: TextStyle(
                        color: mainBlue.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * 3.14159,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainBlue),
                  strokeWidth: 3,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: TextStyle(
              color: mainBlue.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Function() onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 56, color: mainBlue.withOpacity(0.3)),
            const SizedBox(height: 24),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy,
                size: 48,
                color: mainBlue.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventListView(RxList events, bool showType) {
    return RefreshIndicator(
      onRefresh: showType
          ? controller.fetchLombaBeasiswaEvents
          : controller.fetchKegiatanEvents,
      color: mainBlue,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return _buildEventCard(event, showType);
        },
      ),
    );
  }

  Widget _buildKegiatanList() {
    return Obx(() {
      if (controller.isLoadingKegiatan.value) {
        return _buildLoadingState();
      }
      if (controller.error.isNotEmpty) {
        return _buildErrorState(controller.fetchKegiatanEvents);
      }
      if (controller.kegiatanEvents.isEmpty) {
        return _buildEmptyState('Tidak ada info kegiatan');
      }
      return _buildEventListView(controller.kegiatanEvents, false);
    });
  }

  Widget _buildLombaBeasiswaList() {
    return Obx(() {
      if (controller.isLoadingLombaBeasiswa.value) {
        return _buildLoadingState();
      }
      if (controller.error.isNotEmpty) {
        return _buildErrorState(controller.fetchLombaBeasiswaEvents);
      }
      if (controller.lombaBeasiswaEvents.isEmpty) {
        return _buildEmptyState('Tidak ada info lomba & beasiswa');
      }
      return _buildEventListView(controller.lombaBeasiswaEvents, true);
    });
  }
}

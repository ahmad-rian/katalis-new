import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/auth_controller.dart';
import 'components/post_card.dart';
import 'components/create_post_dialog.dart';
import 'widgets/loading_indicator.dart';
import '../../models/post_model.dart';

class PostScreen extends GetView<PostController> {
  PostScreen({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _setupScrollListener();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[50],
      appBar: _buildModernAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: _buildBody(context),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.2),
        child: FloatingActionButton(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          highlightElevation: 8,
          onPressed: () => _showCreatePostDialog(),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.blue[700] : Colors.grey[600],
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.blue[700] : Colors.grey[600],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Feed',
            style: GoogleFonts.poppins(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'HMIF',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      // actions: [
      //   Container(
      //     margin: const EdgeInsets.only(right: 8),
      //     decoration: BoxDecoration(
      //       color: Colors.grey.withOpacity(0.1),
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     child: IconButton(
      //       icon: Icon(
      //         Icons.refresh_rounded,
      //         color: Theme.of(context).brightness == Brightness.dark
      //             ? Colors.white
      //             : Colors.black,
      //       ),
      //       onPressed: () => controller.fetchPosts(refresh: true),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.posts.isEmpty) {
        return const Center(
          child: LoadingIndicator(message: 'Getting latest posts...'),
        );
      }

      if (controller.error.isNotEmpty && controller.posts.isEmpty) {
        return _buildModernErrorState();
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchPosts(refresh: true),
        color: Colors.blue[700],
        child: _buildModernPostList(context),
      );
    });
  }

  Widget _buildModernPostList(BuildContext context) {
    if (controller.posts.isEmpty) {
      return _buildModernEmptyState(context);
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: controller.posts.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.posts.length) {
          return _buildLoadMoreIndicator();
        }

        final post = controller.posts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PostCard(
            post: post,
            onLike: (post) => controller.likePost(post),
            onUnlike: (post) => controller.unlikePost(post),
            onRepost: (post) => controller.repost(post),
            onDelete: (post) => controller.deletePost(post),
          ),
        );
      },
    );
  }

  Widget _buildModernEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[700]?.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.post_add_rounded,
              size: 48,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Posts Yet',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to share something amazing!',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showCreatePostDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Create Post',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something Went Wrong',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.fetchPosts(refresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'Try Again',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFAB(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        highlightElevation: 8,
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (!controller.hasMore.value) return const SizedBox();
      if (controller.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700]?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  void _showCreatePostDialog() {
    Get.dialog(
      CreatePostDialog(
        onCreate: (content, images) {
          controller.createPost(content, images);
        },
      ),
      barrierDismissible: false,
    );
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!controller.isLoading.value && controller.hasMore.value) {
          controller.fetchPosts();
        }
      }
    });
  }
}

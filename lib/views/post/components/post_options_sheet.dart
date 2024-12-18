import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/post_controller.dart';
import '../../../models/post_model.dart';

class PostOptionsSheet extends GetView<AuthController> {
  final Post post;
  final VoidCallback onDelete;
  final postController = Get.find<PostController>();
  final RxBool isDeleting = false.obs;
  final RxBool isEditing = false.obs;

  PostOptionsSheet({
    Key? key,
    required this.post,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Obx(() {
              final bool isOwnPost = post.userId == controller.user?.id;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isOwnPost) ...[
                    _buildOption(
                      icon: Icons.edit,
                      text: 'Edit Post',
                      onTap: () {
                        Get.back();
                        _showEditDialog();
                      },
                    ),
                    _buildOption(
                      icon: Icons.delete,
                      text: 'Delete Post',
                      textColor: Colors.red,
                      onTap: () {
                        Get.back();
                        _showDeleteConfirmation();
                      },
                    ),
                  ],
                  _buildOption(
                    icon: Icons.share,
                    text: 'Share Post',
                    onTap: () {
                      Get.back();
                      // Implement share functionality
                    },
                  ),
                  _buildOption(
                    icon: Icons.bookmark_border,
                    text: 'Save Post',
                    onTap: () {
                      Get.back();
                      // Implement save functionality
                    },
                  ),
                  _buildOption(
                    icon: Icons.flag,
                    text: 'Report Post',
                    onTap: () {
                      Get.back();
                      // Implement report functionality
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[800]),
      title: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor ?? Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showEditDialog() {
    final TextEditingController contentController =
        TextEditingController(text: post.content);
    final RxBool isPrivate = post.isPrivate.obs;

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Post',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                    title: Text('Private Post', style: GoogleFonts.inter()),
                    value: isPrivate.value,
                    onChanged: (value) => isPrivate.value = value ?? false,
                  )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => ElevatedButton(
                        onPressed: isEditing.value
                            ? null
                            : () async {
                                if (contentController.text.trim().isEmpty)
                                  return;

                                isEditing.value = true;
                                try {
                                  await postController.editPost(
                                    post,
                                    contentController.text.trim(),
                                    isPrivate: isPrivate.value,
                                  );
                                } finally {
                                  isEditing.value = false;
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: isEditing.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: GoogleFonts.inter(color: Colors.white),
                              ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Inside PostOptionsSheet class...

  Future<void> _handleDelete() async {
    if (isDeleting.value) return;

    try {
      isDeleting.value = true;
      Get.back(); // Close dialog immediately

      final success = await postController.deletePost(post);
      if (success) {
        // Wait a moment before calling onDelete to ensure UI is ready
        await Future.delayed(const Duration(milliseconds: 100));
        onDelete();
      }
    } finally {
      isDeleting.value = false;
    }
  }

  void _showDeleteConfirmation() {
    final isProcessing = false.obs;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Post',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
              ),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: isProcessing.value
                    ? null
                    : () async {
                        if (isProcessing.value) return;
                        isProcessing.value = true;
                        await _handleDelete();
                        isProcessing.value = false;
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: isProcessing.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Delete',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
              )),
        ],
      ),
    );
  }
}

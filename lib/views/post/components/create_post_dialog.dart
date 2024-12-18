import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostDialog extends StatefulWidget {
  final Function(String, List<File>) onCreate;

  const CreatePostDialog({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController contentController = TextEditingController();
  final List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildContentInput(),
            if (selectedImages.isNotEmpty) _buildImagePreview(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Create Post',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildContentInput() {
    return Expanded(
      child: TextField(
        controller: contentController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'What\'s on your mind?',
          hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
          border: InputBorder.none,
        ),
        autofocus: true,
        style: GoogleFonts.inter(
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == selectedImages.length) {
            return _buildAddImageButton();
          }
          return _buildImageItem(selectedImages[index], index);
        },
      ),
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey[600],
          size: 32,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.photo_library_outlined,
            color: Colors.grey[700],
          ),
          onPressed: _pickImage,
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _createPost,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Post',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        selectedImages.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _createPost() {
    if (contentController.text.trim().isEmpty && selectedImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add some content or images to your post',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    widget.onCreate(contentController.text, selectedImages);
    Get.back();
  }
}

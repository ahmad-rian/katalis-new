import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_con/models/comment_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:pos_con/models/post_model.dart';
import 'package:pos_con/controllers/auth_controller.dart';

class PostController extends GetxController {
  // Base URL getter optimized for iOS and Web
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    // For iOS simulator
    return 'http://127.0.0.1:8000/api';
  }

  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt page = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('PostController initialized');
    // Listen for auth changes
    ever(authController.currentUser, (user) {
      if (user != null && !isInitialized.value) {
        print('User logged in, fetching posts');
        fetchPosts();
        isInitialized.value = true;
      }
    });
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (!authController.isLoggedIn) {
      print('User not logged in');
      error.value = 'Please login to view posts';
      return;
    }

    if (refresh) {
      print('Refreshing posts');
      page.value = 1;
      hasMore.value = true;
      posts.clear();
    }

    if (!hasMore.value && !refresh) return;

    try {
      isLoading(true);
      error('');

      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      print('Fetching posts from: $baseUrl/posts?page=${page.value}');

      final response = await http
          .get(
            Uri.parse('$baseUrl/posts?page=${page.value}'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final List<Post> newPosts = (data['data'] as List)
              .map((post) => Post.fromJson(post))
              .toList();

          print('Received ${newPosts.length} posts');
          posts.addAll(newPosts);

          if (newPosts.length < 20) {
            hasMore.value = false;
          } else {
            page.value++;
          }
        } else {
          throw Exception(data['message'] ?? 'Invalid response format');
        }
      } else if (response.statusCode == 401) {
        await authController.logout(showMessage: false);
        error.value = 'Session expired. Please login again.';
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createPost(String content, List<File>? media,
      {bool isPrivate = false}) async {
    try {
      isLoading(true);
      error('');

      print('Creating post with content length: ${content.length}');

      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/posts'),
      );

      // Add text fields
      request.fields['content'] = content;
      request.fields['is_private'] = isPrivate ? '1' : '0';

      // Add files if any
      if (media != null && media.isNotEmpty) {
        print('Adding ${media.length} media files');
        for (var file in media) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile(
            'media[]',
            stream,
            length,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Add headers
      request.headers.addAll(headers);

      print('Sending post request');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('Create post response status: ${response.statusCode}');
      print('Create post response: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseData);
        if (data['status'] == true && data['data'] != null) {
          final newPost = Post.fromJson(data['data']);
          posts.insert(0, newPost);
          Get.back(); // Close create post dialog
          Get.snackbar(
            'Success',
            'Post created successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to create post');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
      error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to create post: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> repost(Post post, {String? content}) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      final response = await http.post(
        Uri.parse('$baseUrl/posts/${post.id}/repost'),
        headers: headers,
        body: json.encode({
          'content': content,
        }),
      );

      print('Repost response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final newPost = Post.fromJson(data['data']);
          posts.insert(0, newPost);

          // Update original post repost count
          final index = posts.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            posts[index] = Post(
              id: post.id,
              userId: post.userId,
              content: post.content,
              media: post.media,
              originalPostId: post.originalPostId,
              isPinned: post.isPinned,
              isPrivate: post.isPrivate,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              repostCount: post.repostCount + 1,
              isLiked: post.isLiked,
              createdAt: post.createdAt,
              user: post.user,
              postMedia: post.postMedia,
            );
          }
          Get.back(); // Close repost dialog
          Get.snackbar(
            'Success',
            'Post reposted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to repost');
        }
      } else {
        throw Exception('Failed to repost: ${response.statusCode}');
      }
    } catch (e) {
      print('Error reposting: $e');
      error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to repost: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> likePost(Post post) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      final response = await http.post(
        Uri.parse('$baseUrl/posts/${post.id}/like'),
        headers: headers,
      );

      print('Like post response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final index = posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          posts[index] = Post(
            id: post.id,
            userId: post.userId,
            content: post.content,
            media: post.media,
            originalPostId: post.originalPostId,
            isPinned: post.isPinned,
            isPrivate: post.isPrivate,
            likeCount: post.likeCount + 1,
            commentCount: post.commentCount,
            repostCount: post.repostCount,
            isLiked: true,
            createdAt: post.createdAt,
            user: post.user,
            postMedia: post.postMedia,
          );
        }
      } else {
        throw Exception('Failed to like post');
      }
    } catch (e) {
      print('Error liking post: $e');
      error(e.toString());
      Get.snackbar('Error', 'Failed to like post');
    }
  }

  Future<void> unlikePost(Post post) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      final response = await http.delete(
        Uri.parse('$baseUrl/posts/${post.id}/like'),
        headers: headers,
      );

      print('Unlike post response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final index = posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          posts[index] = Post(
            id: post.id,
            userId: post.userId,
            content: post.content,
            media: post.media,
            originalPostId: post.originalPostId,
            isPinned: post.isPinned,
            isPrivate: post.isPrivate,
            likeCount: post.likeCount - 1,
            commentCount: post.commentCount,
            repostCount: post.repostCount,
            isLiked: false,
            createdAt: post.createdAt,
            user: post.user,
            postMedia: post.postMedia,
          );
        }
      } else {
        throw Exception('Failed to unlike post');
      }
    } catch (e) {
      print('Error unliking post: $e');
      error(e.toString());
      Get.snackbar('Error', 'Failed to unlike post');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = authController.currentToken;
    if (token == null) {
      print('No token found');
      await authController.logout(showMessage: false);
      error.value = 'Please login to continue';
      return {};
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  final RxMap<int, RxList<Comment>> postComments = <int, RxList<Comment>>{}.obs;

  Future<List<Comment>> getComments(int postId) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId/comments'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true && responseData['data'] != null) {
          // Mengambil array data dari dalam struktur pagination
          final paginationData = responseData['data'];
          final List<dynamic> commentsData = paginationData['data'] ?? [];

          final comments =
              commentsData.map((comment) => Comment.fromJson(comment)).toList();

          postComments[postId] = RxList<Comment>.from(comments);
          return comments;
        }
        return [];
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error loading comments: $e');
      return [];
    }
  }

  Future<void> addComment(Post post, String content) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      final response = await http.post(
        Uri.parse('$baseUrl/posts/${post.id}/comments'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': content,
        }),
      );

      print('Response add comment: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          final newComment = Comment.fromJson(responseData['data']);

          // Update comments list
          if (!postComments.containsKey(post.id)) {
            postComments[post.id] = RxList<Comment>([]);
          }
          postComments[post.id]?.insert(0, newComment);

          // Update post comment count
          final index = posts.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            final updatedPost = Post(
              id: post.id,
              userId: post.userId,
              content: post.content,
              media: post.media,
              originalPostId: post.originalPostId,
              isPinned: post.isPinned,
              isPrivate: post.isPrivate,
              likeCount: post.likeCount,
              commentCount: post.commentCount + 1,
              repostCount: post.repostCount,
              isLiked: post.isLiked,
              createdAt: post.createdAt,
              user: post.user,
              postMedia: post.postMedia,
            );
            posts[index] = updatedPost;
          }
          Get.back();
          Get.snackbar(
            'Success',
            'Comment added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to add comment');
        }
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding comment: $e');
      Get.snackbar(
        'Error',
        'Failed to add comment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editPost(Post post, String newContent, {bool? isPrivate}) async {
    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return;

      final response = await http.put(
        Uri.parse('$baseUrl/posts/${post.id}'),
        headers: {
          'Authorization': headers['Authorization']!,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': newContent,
          if (isPrivate != null) 'is_private': isPrivate,
        }),
      );

      print('Edit post response: ${response.statusCode}');
      print('Edit post response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final updatedPost = Post.fromJson(data['data']);
          final index = posts.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            posts[index] = updatedPost;
          }
          Get.back(); // Close edit dialog
          Get.snackbar(
            'Success',
            'Post updated successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to update post');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ??
            'Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating post: $e');
      Get.snackbar(
        'Error',
        'Failed to update post: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  final _completedDeletions = <int>{};

  Future<bool> deletePost(Post post) async {
    // Check if post was already successfully deleted
    if (_completedDeletions.contains(post.id)) {
      print('Post ${post.id} was already deleted');
      return true;
    }

    try {
      final headers = await _getHeaders();
      if (headers.isEmpty) return false;

      final response = await http.delete(
        Uri.parse('$baseUrl/posts/${post.id}'),
        headers: headers,
      );

      print('Delete post response: ${response.statusCode}');
      print('Delete post response body: ${response.body}');

      if (response.statusCode == 200) {
        // Mark post as deleted and remove from list
        _completedDeletions.add(post.id);
        posts.removeWhere((p) => p.id == post.id);

        Get.snackbar(
          'Success',
          'Post deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print('Error deleting post: $e');

      // If post not found (404), consider it already deleted
      if (e.toString().contains('No query results for model')) {
        _completedDeletions.add(post.id);
        posts.removeWhere((p) => p.id == post.id);
        return true;
      }

      Get.snackbar(
        'Error',
        'Failed to delete post',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  @override
  void onClose() {
    _completedDeletions.clear();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:pos_con/models/comment_model.dart';

class Post {
  final int id;
  final int userId;
  final String content;
  final List<String>? media;
  final String? originalPostId;
  final Post? originalPost;
  final bool isPinned;
  final bool isPrivate;
  final int likeCount;
  final int commentCount;
  final int repostCount;
  final bool isLiked;
  final String createdAt;
  final User? user;
  final List<PostMedia>? postMedia;
  final List<String>? hashtags;
  final List<Comment>? comments; // Tambahkan field comments

  Post({
    required this.id,
    required this.userId,
    required this.content,
    this.media,
    this.originalPostId,
    this.originalPost,
    this.isPinned = false,
    this.isPrivate = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.repostCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.user,
    this.postMedia,
    this.hashtags,
    this.comments, // Tambahkan di constructor
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        content: json['content'] ?? '',
        media: json['media'] != null ? List<String>.from(json['media']) : null,
        originalPostId: json['original_post_id']?.toString(),
        originalPost: json['original_post'] != null
            ? Post.fromJson(json['original_post'])
            : null,
        isPinned: json['is_pinned'] == 1 || json['is_pinned'] == true,
        isPrivate: json['is_private'] == 1 || json['is_private'] == true,
        likeCount: json['like_count'] ?? 0,
        commentCount: json['comment_count'] ?? 0,
        repostCount: json['repost_count'] ?? 0,
        isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
        createdAt: json['created_at'] ?? '',
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        postMedia:
            json['media'] != null ? _parsePostMedia(json['media']) : null,
        hashtags: json['hashtags'] != null
            ? List<String>.from(json['hashtags'])
            : null,
        comments:
            _parseComments(json['comments']), // Tambahkan parsing comments
      );
    } catch (e) {
      print('Error parsing Post: $e');
      print('JSON data: $json');
      throw Exception('Failed to parse Post data: $e');
    }
  }

  // Tambahkan fungsi parsing untuk comments
  static List<Comment>? _parseComments(dynamic commentsJson) {
    if (commentsJson == null || !(commentsJson is List)) return null;
    try {
      return List<Comment>.from(commentsJson.map((x) => Comment.fromJson(x)))
          .where((comment) => comment != null)
          .toList();
    } catch (e) {
      print('Error parsing comments: $e');
      return null;
    }
  }

  static List<PostMedia>? _parsePostMedia(dynamic mediaJson) {
    if (mediaJson == null || !(mediaJson is List)) return null;
    try {
      return mediaJson
          .map((media) {
            if (media is Map<String, dynamic>) {
              return PostMedia.fromJson(media);
            }
            // Handle jika media berupa string URL
            if (media is String) {
              return PostMedia(
                id: 0,
                type: 'image',
                url: media,
              );
            }
            throw Exception('Invalid media format');
          })
          .toList()
          .cast<PostMedia>();
    } catch (e) {
      print('Error parsing PostMedia: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'media': media,
      'original_post_id': originalPostId,
      'original_post': originalPost?.toJson(),
      'is_pinned': isPinned,
      'is_private': isPrivate,
      'like_count': likeCount,
      'comment_count': commentCount,
      'repost_count': repostCount,
      'is_liked': isLiked,
      'created_at': createdAt,
      'user': user?.toJson(),
      'post_media': postMedia?.map((x) => x.toJson()).toList(),
      'hashtags': hashtags,
    };
  }
}

class PostMedia {
  final int id;
  final String type;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? duration;

  PostMedia({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.duration,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    try {
      return PostMedia(
        id: json['id'] ?? 0,
        type: json['type'] ?? 'image',
        url: json['url'] ?? '',
        thumbnailUrl: json['thumbnail_url'],
        width: json['width']?.toInt(),
        height: json['height']?.toInt(),
        duration: json['duration']?.toInt(),
      );
    } catch (e) {
      print('Error parsing PostMedia: $e');
      throw Exception('Failed to parse PostMedia data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'duration': duration,
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? token;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    try {
      String profileUrl = json['profile_image_url'] ??
          json['avatar_url'] ??
          json['avatar'] ??
          'assets/images/default-profile.png';

      if (!profileUrl.startsWith('http')) {
        const baseUrl = 'http://127.0.0.1:8000';
        profileUrl = profileUrl.startsWith('/')
            ? baseUrl + profileUrl
            : '$baseUrl/storage/$profileUrl';
      }

      return User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        token: token ?? json['token'],
        profileImageUrl: profileUrl, // Now this will never be null
      );
    } catch (e) {
      print('Error parsing User: $e');
      print('JSON data: $json');
      throw Exception('Failed to parse User data: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profile_image_url': profileImageUrl,
      };
}

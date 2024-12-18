import 'package:pos_con/models/user_model.dart';

class Comment {
  final int id;
  final int userId;
  final int postId;
  final int? parentId;
  final String content;
  final List<String>? media;
  final int likeCount;
  final bool isLiked;
  final String createdAt;
  final User user;
  final List<Comment>? replies;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    this.parentId,
    required this.content,
    this.media,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
    required this.user,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    try {
      String parsedDate = DateTime.now().toIso8601String();

      if (json['formatted_created_at'] != null) {
        parsedDate = json['formatted_created_at'];
      } else if (json['created_at'] != null) {
        try {
          parsedDate = DateTime.parse(json['created_at']).toIso8601String();
        } catch (e) {
          print('Error parsing date: $e');
          // Keep default current date if parsing fails
        }
      }

      return Comment(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        postId: json['post_id'] ?? 0,
        parentId: json['parent_id'],
        content: json['content'] ?? '',
        media: json['media'] != null ? List<String>.from(json['media']) : null,
        likeCount: json['like_count'] ?? 0,
        isLiked: json['is_liked'] ?? false,
        createdAt: parsedDate,
        user: User.fromJson(json['user'] ?? {}),
        replies: _parseReplies(json['replies']),
      );
    } catch (e) {
      print('Error parsing Comment: $e');
      print('JSON data: $json'); // untuk debug
      throw Exception('Failed to parse Comment data');
    }
  }

  static List<Comment>? _parseReplies(dynamic repliesJson) {
    if (repliesJson == null || !(repliesJson is List)) return null;
    try {
      return List<Comment>.from(
        repliesJson.map((x) => Comment.fromJson(x)),
      );
    } catch (e) {
      print('Error parsing replies: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'parent_id': parentId,
      'content': content,
      'media': media,
      'like_count': likeCount,
      'is_liked': isLiked,
      'created_at': createdAt,
      'user': user.toJson(),
      'replies': replies?.map((x) => x.toJson()).toList(),
    };
  }
}

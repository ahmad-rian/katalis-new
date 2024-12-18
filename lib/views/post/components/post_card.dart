import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/media_gallery.dart';
import '../components/comment_dialog.dart';
import '../components/post_options_sheet.dart';
import '../components/repost_dialog.dart';
import '../widgets/interaction_button.dart';

class PostCard extends StatelessWidget {
  final dynamic post;
  final Function(dynamic) onLike;
  final Function(dynamic) onUnlike;
  final Function(dynamic) onRepost;
  final Function(dynamic) onDelete;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onUnlike,
    required this.onRepost,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
          if (post.postMedia != null && post.postMedia!.isNotEmpty)
            MediaGallery(media: post.postMedia!),
          _buildInteractions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: CircleAvatar(
        backgroundImage: post.user.profileImageUrl != null
            ? NetworkImage(post.user.profileImageUrl!)
            : null,
        child: post.user.profileImageUrl == null
            ? Text(post.user.name[0].toUpperCase())
            : null,
      ),
      title: Text(
        post.user.name,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        timeago.format(DateTime.parse(post.createdAt)),
        style: GoogleFonts.inter(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
        onPressed: () => _showOptions(),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original post reference if it's a repost
          if (post.originalPost != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reposted from ${post.originalPost.user.name}',
                    style: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.originalPost.content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

          // Main post content
          Text(
            post.content,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.4,
            ),
          ),

          // Hashtags
          if (post.hashtags != null && post.hashtags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 4,
                children: post.hashtags.map<Widget>((hashtag) {
                  return Text(
                    '#$hashtag',
                    style: GoogleFonts.inter(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InteractionButton(
            icon: post.isLiked ? Icons.favorite : Icons.favorite_outline,
            color: post.isLiked ? Colors.red : Colors.grey[600]!,
            count: post.likeCount,
            onTap: () => post.isLiked ? onUnlike(post) : onLike(post),
          ),
          const SizedBox(width: 24),
          InteractionButton(
            icon: Icons.comment_outlined,
            color: Colors.grey[600]!,
            count: post.commentCount,
            onTap: () => _showComments(),
          ),
          const SizedBox(width: 24),
          InteractionButton(
            icon: Icons.repeat,
            color: Colors.grey[600]!,
            count: post.repostCount,
            onTap: () => _showRepostDialog(),
          ),
        ],
      ),
    );
  }

  void _showComments() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: CommentDialog(post: post),
      ),
    );
  }

  void _showRepostDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: RepostDialog(
          post: post,
          onRepost: () => onRepost(post),
        ),
      ),
    );
  }

  void _showOptions() {
    Get.bottomSheet(
      PostOptionsSheet(
        post: post,
        onDelete: () => onDelete(post),
      ),
    );
  }
}

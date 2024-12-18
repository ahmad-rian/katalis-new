<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class PostController extends Controller
{
    public function index()
    {
        try {
            $posts = Post::query()
                ->withCount(['likes', 'comments'])
                ->with(['user', 'media']) // Eager load relationships
                ->where(function ($query) {
                    $query->where('is_private', false)
                        ->orWhere('user_id', auth()->id());
                })
                ->latest()
                ->paginate(20);

            return response()->json([
                'status' => true,
                'message' => 'Posts retrieved successfully',
                'data' => $posts->items(),
                'meta' => [
                    'current_page' => $posts->currentPage(),
                    'last_page' => $posts->lastPage(),
                    'per_page' => $posts->perPage(),
                    'total' => $posts->total()
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error retrieving posts: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve posts'
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'content' => 'required|string|max:1000',
                'media.*' => 'nullable|image|max:5120', // 5MB max per image
                'is_private' => 'boolean'
            ]);

            DB::beginTransaction();

            $post = Post::create([
                'user_id' => auth()->id(),
                'content' => $validated['content'],
                'is_private' => $validated['is_private'] ?? false,
            ]);

            if ($request->hasFile('media')) {
                foreach ($request->file('media') as $media) {
                    $path = $media->store('posts', 'public');
                    $post->media()->create([
                        'type' => 'image',
                        'url' => $path,
                    ]);
                }
            }

            // Reload post with relationships
            $post->load(['user', 'media']);

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Post created successfully',
                'data' => $post
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error creating post: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to create post'
            ], 500);
        }
    }

    public function update(Request $request, Post $post)
    {
        try {
            if ($post->user_id !== auth()->id()) {
                return response()->json([
                    'status' => false,
                    'message' => 'You are not authorized to update this post'
                ], 403);
            }

            $validated = $request->validate([
                'content' => 'required|string|max:1000',
                'is_private' => 'boolean'
            ]);

            DB::beginTransaction();

            $post->update([
                'content' => $validated['content'],
                'is_private' => $validated['is_private'] ?? $post->is_private,
            ]);

            // Reload post with relationships
            $post->load(['user', 'media']);

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Post updated successfully',
                'data' => $post
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error updating post: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to update post'
            ], 500);
        }
    }

    public function destroy(Post $post)
    {
        try {
            if ($post->user_id !== auth()->id()) {
                return response()->json([
                    'status' => false,
                    'message' => 'You are not authorized to delete this post'
                ], 403);
            }

            DB::beginTransaction();

            // Delete comments first
            $post->comments()->delete();

            // Delete likes
            $post->likes()->delete();

            // Delete media files if any
            if ($post->media()->exists()) {
                foreach ($post->media as $media) {
                    try {
                        if (Storage::disk('public')->exists($media->url)) {
                            Storage::disk('public')->delete($media->url);
                        }
                    } catch (\Exception $e) {
                        Log::warning('Failed to delete media file: ' . $e->getMessage());
                        // Continue with deletion even if file removal fails
                    }
                    $media->delete();
                }
            }

            // Finally delete the post
            $post->delete();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Post deleted successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error deleting post: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json([
                'status' => false,
                'message' => 'Failed to delete post: ' . $e->getMessage()
            ], 500);
        }
    }

    public function like(Post $post)
    {
        try {
            DB::beginTransaction();

            $post->likes()->updateOrCreate(
                ['user_id' => auth()->id()],
                ['created_at' => now()]
            );

            $post->increment('like_count');
            $post->load('user');

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Post liked successfully',
                'data' => $post
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error liking post: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to like post'
            ], 500);
        }
    }

    public function unlike(Post $post)
    {
        try {
            DB::beginTransaction();

            $post->likes()->where('user_id', auth()->id())->delete();
            $post->decrement('like_count');
            $post->load('user');

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Post unliked successfully',
                'data' => $post
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error unliking post: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to unlike post'
            ], 500);
        }
    }

    public function comment(Request $request, Post $post)
    {
        try {
            $validated = $request->validate([
                'content' => 'required|string|max:500',
                'parent_id' => 'nullable|exists:post_comments,id'
            ]);

            DB::beginTransaction();

            $comment = $post->comments()->create([
                'user_id' => auth()->id(),
                'content' => $validated['content'],
                'parent_id' => $validated['parent_id'] ?? null
            ]);

            $post->increment('comment_count');

            // Load relationships and format date
            $comment->load('user');
            $comment->created_at = $comment->created_at->toIso8601String();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Comment added successfully',
                'data' => $comment
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error adding comment: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to add comment'
            ], 500);
        }
    }

    public function getComments(Post $post)
    {
        try {
            $comments = $post->comments()
                ->whereNull('parent_id')
                ->with(['user', 'replies.user'])
                ->withCount('likes')
                ->latest()
                ->paginate(20);

            return response()->json([
                'status' => true,
                'message' => 'Comments retrieved successfully',
                'data' => $comments
            ]);
        } catch (\Exception $e) {
            Log::error('Error retrieving comments: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve comments'
            ], 500);
        }
    }
}

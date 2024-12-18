<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        // Posts table
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->text('content');
            $table->json('media')->nullable(); // For images/videos
            $table->integer('like_count')->default(0);
            $table->integer('comment_count')->default(0);
            $table->integer('repost_count')->default(0);
            $table->foreignId('original_post_id')->nullable()->references('id')->on('posts')->onDelete('set null'); // For reposts
            $table->boolean('is_pinned')->default(false); // For pinned posts
            $table->boolean('is_private')->default(false); // Privacy setting
            $table->timestamps();
            $table->softDeletes();

            $table->index(['user_id', 'created_at']); // For efficient user timeline queries
            $table->index(['created_at']); // For global timeline queries
        });

        // Post media table
        Schema::create('post_media', function (Blueprint $table) {
            $table->id();
            $table->foreignId('post_id')->constrained()->onDelete('cascade');
            $table->string('type'); // image, video, etc.
            $table->string('url');
            $table->string('thumbnail_url')->nullable();
            $table->integer('width')->nullable();
            $table->integer('height')->nullable();
            $table->integer('duration')->nullable(); // For videos
            $table->timestamps();
        });

        // Likes table
        Schema::create('post_likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('post_id')->constrained()->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'post_id']);
            $table->index(['post_id', 'created_at']); // For likes list queries
        });

        // Comments table
        Schema::create('post_comments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('post_id')->constrained()->onDelete('cascade');
            $table->foreignId('parent_id')->nullable()->references('id')->on('post_comments')->onDelete('cascade'); // For nested comments
            $table->text('content');
            $table->integer('like_count')->default(0);
            $table->json('media')->nullable(); // For comment attachments
            $table->timestamps();
            $table->softDeletes();

            $table->index(['post_id', 'created_at']); // For comment list queries
        });

        // Comment likes table
        Schema::create('comment_likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('comment_id')->references('id')->on('post_comments')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'comment_id']);
        });

        // Mentions table
        Schema::create('post_mentions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('post_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Mentioned user
            $table->timestamps();

            $table->unique(['post_id', 'user_id']);
            $table->index(['user_id', 'created_at']); // For mentions timeline
        });

        // Hashtags table
        Schema::create('hashtags', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->integer('usage_count')->default(0);
            $table->timestamps();
        });

        // Post hashtags pivot table
        Schema::create('post_hashtags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('post_id')->constrained()->onDelete('cascade');
            $table->foreignId('hashtag_id')->constrained()->onDelete('cascade');
            $table->timestamps();

            $table->unique(['post_id', 'hashtag_id']);
            $table->index(['hashtag_id', 'created_at']); // For hashtag timeline
        });
    }

    public function down()
    {
        Schema::dropIfExists('post_hashtags');
        Schema::dropIfExists('hashtags');
        Schema::dropIfExists('post_mentions');
        Schema::dropIfExists('comment_likes');
        Schema::dropIfExists('post_comments');
        Schema::dropIfExists('post_likes');
        Schema::dropIfExists('post_media');
        Schema::dropIfExists('posts');
    }
};

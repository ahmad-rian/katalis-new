<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class Post extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'user_id',
        'content',
        'is_private',
        'media',
        'like_count',
        'comment_count',
        'repost_count'
    ];

    protected $casts = [
        'is_private' => 'boolean',
        'media' => 'array'
    ];

    protected $with = ['user', 'media'];

    protected $appends = ['is_liked'];

    public function scopeVisible($query)
    {
        return $query->where(function ($q) {
            $q->where('is_private', false)
                ->orWhere('user_id', auth()->id());
        });
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function likes()
    {
        return $this->hasMany(PostLike::class);
    }

    public function comments()
    {
        return $this->hasMany(PostComment::class);
    }

    public function media()
    {
        return $this->hasMany(PostMedia::class);
    }

    public function isLikedBy($userId)
    {
        return $this->likes()->where('user_id', $userId)->exists();
    }

    public function getIsLikedAttribute()
    {
        return $this->isLikedBy(auth()->id() ?? 0);
    }
}

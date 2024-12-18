<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PostMedia extends Model
{
    protected $table = 'post_media';

    protected $fillable = [
        'post_id',
        'type',
        'url',
        'thumbnail_url',
        'width',
        'height',
        'duration'
    ];

    public function post()
    {
        return $this->belongsTo(Post::class);
    }
}

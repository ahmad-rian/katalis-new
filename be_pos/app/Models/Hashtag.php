<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Hashtag extends Model
{
    protected $fillable = [
        'name',
        'usage_count'
    ];

    public function posts()
    {
        return $this->belongsToMany(Post::class, 'post_hashtags')
            ->withTimestamps();
    }

    public static function findOrCreate($name)
    {
        $name = strtolower($name);
        return static::firstOrCreate(
            ['name' => $name],
            ['usage_count' => 0]
        );
    }

    public function incrementUsage()
    {
        $this->increment('usage_count');
    }

    public function decrementUsage()
    {
        $this->decrement('usage_count');
    }
}

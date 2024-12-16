<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class Member extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'nim',
        'name',
        'batch_year',
        'faculty',
        'study_program',
        'profile_image',
    ];

    protected $appends = ['profile_image_url'];

    protected $casts = [
        'batch_year' => 'integer',
    ];

    /**
     * Filter members by batch year
     */
    public function scopeByBatch($query, $year)
    {
        return $query->where('batch_year', $year);
    }

    /**
     * Filter members by faculty
     */
    public function scopeByFaculty($query, $faculty)
    {
        return $query->where('faculty', $faculty);
    }

    /**
     * Filter members by study program
     */
    public function scopeByStudyProgram($query, $program)
    {
        return $query->where('study_program', $program);
    }

    /**
     * Get profile image URL
     *
     * @return string
     */
    public function getProfileImageUrlAttribute()
    {
        if ($this->profile_image && Storage::disk('public')->exists($this->profile_image)) {
            return asset('storage/' . $this->profile_image);
        }

        return asset('images/default-profile.png');
    }

    /**
     * Format member data for API response
     *
     * @return array
     */
    public function toArray()
    {
        $data = parent::toArray();
        $data['profile_image_url'] = $this->profile_image_url;
        return $data;
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Member extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'nim',
        'name',
        'batch_year',
        'faculty',
        'study_program',
        'profile_image', // Tambahkan kolom untuk menyimpan path gambar
    ];
    protected $appends = ['profile_image_url'];

    // Casts untuk memastikan data batch_year selalu integer
    protected $casts = [
        'batch_year' => 'integer',
    ];

    /**
     * Scope untuk filter berdasarkan angkatan.
     */
    public function scopeByBatch($query, $year)
    {
        return $query->where('batch_year', $year);
    }

    /**
     * Scope untuk filter berdasarkan fakultas.
     */
    public function scopeByFaculty($query, $faculty)
    {
        return $query->where('faculty', $faculty);
    }

    /**
     * Scope untuk filter berdasarkan program studi.
     */
    public function scopeByStudyProgram($query, $program)
    {
        return $query->where('study_program', $program);
    }

    /**
     * Akses URL gambar profil.
     */
    public function getProfileImageUrlAttribute()
    {
        // Mengembalikan URL gambar jika ada, atau placeholder jika tidak ada
        return $this->profile_image
            ? asset('storage/' . $this->profile_image)
            : asset('images/default-profile.png'); // Placeholder default
    }
}

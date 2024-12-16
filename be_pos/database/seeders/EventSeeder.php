<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Event;

class EventSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Event::insert([
            [
                'nama_event' => 'Seminar Nasional Teknologi',
                'deskripsi' => 'Seminar membahas tren teknologi terbaru untuk industri 4.0.',
                'jenis' => 'Teknologi',
                'gambar' => null, // Jika tidak ada gambar
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama_event' => 'Lomba Karya Tulis Ilmiah',
                'deskripsi' => 'Lomba untuk mahasiswa yang gemar menulis karya ilmiah.',
                'jenis' => 'Akademik',
                'gambar' => null, // Jika tidak ada gambar
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama_event' => 'Festival Seni dan Budaya',
                'deskripsi' => 'Ajang menampilkan kebudayaan dan seni dari berbagai daerah.',
                'jenis' => 'Seni',
                'gambar' => null, // Jika tidak ada gambar
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
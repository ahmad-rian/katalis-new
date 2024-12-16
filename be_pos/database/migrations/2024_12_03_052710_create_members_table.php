<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('members', function (Blueprint $table) {
            $table->id();
            $table->string('nim', 20)->unique();
            $table->string('name');
            $table->year('batch_year'); // angkatan
            $table->string('faculty');
            $table->string('study_program');
            $table->string('profile_image')->nullable(); // Kolom untuk menyimpan gambar profil
            $table->timestamps();
            $table->softDeletes(); // Jika ingin menggunakan soft delete
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('members');
    }
};

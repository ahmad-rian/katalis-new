<?php

namespace Database\Seeders;

use App\Models\Member;
use Illuminate\Database\Seeder;

class MemberSeeder extends Seeder
{
    public function run()
    {
        Member::truncate();

        $prodi = ['Informatika', 'Teknik Komputer'];
        $names = [
            'Andi',
            'Budi',
            'Cindy',
            'Deni',
            'Eka',
            'Fajar',
            'Gita',
            'Hadi',
            'Indra',
            'Joko',
            'Kartika',
            'Lisa',
            'Mira',
            'Nando',
            'Oscar',
            'Putri',
            'Qori',
            'Rudi',
            'Sinta',
            'Tono',
            'Udin',
            'Vina',
            'Wati',
            'Xavi',
            'Yuda',
            'Zahra'
        ];

        for ($year = 1; $year <= 24; $year++) {
            $yearStr = str_pad($year, 2, '0', STR_PAD_LEFT);

            for ($i = 1; $i <= 2; $i++) {
                $nim = 'H1D0' . $yearStr . str_pad($i, 3, '0', STR_PAD_LEFT);
                $studyProgram = $prodi[array_rand($prodi)];
                $name = $names[array_rand($names)] . ' ' . $names[array_rand($names)];

                Member::create([
                    'nim' => $nim,
                    'name' => $name,
                    'batch_year' => 2000 + intval($yearStr),
                    'faculty' => 'Fakultas Teknik',
                    'study_program' => $studyProgram
                ]);
            }
        }
    }
}

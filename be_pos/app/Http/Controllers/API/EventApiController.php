<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\Request;

class EventApiController extends Controller
{
    public function getKegiatan()
    {
        try {
            $events = Event::where('jenis', 'Info Kegiatan')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Info kegiatan retrieved successfully',
                'data' => $events
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error retrieving events: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getLombaBeasiswa()
    {
        try {
            $events = Event::whereIn('jenis', ['Info Lomba', 'Info Beasiswa'])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Info lomba dan beasiswa retrieved successfully',
                'data' => $events
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Error retrieving events: ' . $e->getMessage()
            ], 500);
        }
    }
}

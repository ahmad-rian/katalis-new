<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Member;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class MemberApiController extends Controller
{
    public function index()
    {
        try {
            $members = Member::latest()->get()->map(function ($member) {
                return $this->formatMemberResponse($member);
            });

            return response()->json([
                'status' => true,
                'data' => $members,
                'message' => 'Members retrieved successfully'
            ], 200);
        } catch (\Exception $e) {
            Log::error('Error retrieving members: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Failed to retrieve members'
            ], 500);
        }
    }

    public function search(Request $request)
    {
        try {
            $query = $request->query('query');
            $members = Member::where('nim', 'like', "%$query%")
                ->orWhere('name', 'like', "%$query%")
                ->get()
                ->map(function ($member) {
                    return $this->formatMemberResponse($member);
                });

            return response()->json([
                'status' => true,
                'data' => $members,
                'message' => 'Search successful'
            ], 200);
        } catch (\Exception $e) {
            Log::error('Error searching members: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Search failed'
            ], 500);
        }
    }

    private function formatMemberResponse($member)
    {
        $data = $member->toArray();
        $data['profile_image_url'] = $member->profile_image
            ? asset('storage/' . $member->profile_image)
            : null;
        return $data;
    }
}

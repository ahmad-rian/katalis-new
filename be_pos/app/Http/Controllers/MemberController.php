<?php

namespace App\Http\Controllers;

use App\Models\Member;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class MemberController extends Controller
{
    public function __construct()
    {
        // Middleware auth dan role:admin hanya untuk metode tertentu
        $this->middleware(['auth', 'role:admin'])->only(['create', 'store', 'edit', 'update', 'destroy']);
    }

    public function index()
    {
        $members = Member::latest()->paginate(10);
        return view('members.index', compact('members'));
    }

    public function indexApi(Request $request)
    {
        try {
            $members = Member::query();

            if ($request->has('nim')) {
                $members->where('nim', 'like', '%' . $request->query('nim') . '%');
            }

            $members = $members->latest()->get();

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
                ->get();

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

    public function create()
    {
        return view('members.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nim' => 'required|string|max:20|unique:members',
            'name' => 'required|string|max:255',
            'batch_year' => 'required|integer|min:2000|max:' . (date('Y')),
            'faculty' => 'required|string|max:255',
            'study_program' => 'required|string|max:255',
            'profile_image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($request->hasFile('profile_image')) {
            $validated['profile_image'] = $request->file('profile_image')->store('profiles', 'public');
        }

        Member::create($validated);

        return redirect()->route('members.index')
            ->with('success', 'Member created successfully.');
    }

    public function edit(Member $member)
    {
        return view('members.edit', compact('member'));
    }

    public function update(Request $request, Member $member)
    {
        $validated = $request->validate([
            'nim' => 'required|string|max:20|unique:members,nim,' . $member->id,
            'name' => 'required|string|max:255',
            'batch_year' => 'required|integer|min:2000|max:' . (date('Y')),
            'faculty' => 'required|string|max:255',
            'study_program' => 'required|string|max:255',
            'profile_image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($request->hasFile('profile_image')) {
            if ($member->profile_image && Storage::disk('public')->exists($member->profile_image)) {
                Storage::disk('public')->delete($member->profile_image);
            }
            $validated['profile_image'] = $request->file('profile_image')->store('profiles', 'public');
        }

        $member->update($validated);

        return redirect()->route('members.index')
            ->with('success', 'Member updated successfully.');
    }

    public function destroy(Member $member)
    {
        if ($member->profile_image) {
            Storage::disk('public')->delete($member->profile_image);
        }

        $member->delete();

        return redirect()->route('members.index')
            ->with('success', 'Member deleted successfully.');
    }
}

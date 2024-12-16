<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\Log;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        try {
            $user = $request->user();
            return response()->json([
                'user' => $user,
                'avatar_url' => $user->avatar_url,
            ]);
        } catch (\Exception $e) {
            Log::error('Error fetching profile:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'message' => 'Failed to fetch profile'
            ], 500);
        }
    }

    public function update(Request $request)
    {
        try {
            $user = $request->user();

            Log::info('Profile update request:', [
                'has_file' => $request->hasFile('avatar'),
                'all_data' => $request->all()
            ]);

            $data = $request->validate([
                'name' => ['nullable', 'string', 'max:255'],
                'avatar' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif', 'max:2048'],
            ]);

            if ($request->hasFile('avatar')) {
                $file = $request->file('avatar');
                Log::info('Uploading avatar:', [
                    'original_name' => $file->getClientOriginalName(),
                    'mime_type' => $file->getMimeType(),
                    'size' => $file->getSize()
                ]);

                // Ensure directory exists
                Storage::disk('public')->makeDirectory('avatars');

                // Delete old avatar if exists
                if ($user->avatar && !str_starts_with($user->avatar, 'images/default-profile.png')) {
                    Storage::disk('public')->delete($user->avatar);
                }

                // Store new avatar
                $avatarPath = $file->store('avatars', 'public');
                $user->avatar = $avatarPath;

                Log::info('Avatar stored:', ['path' => $avatarPath]);
            }

            if ($request->has('name')) {
                $user->name = $data['name'];
            }

            $user->save();

            // Get fresh user data with avatar URL
            $user = $user->fresh();

            return response()->json([
                'user' => array_merge($user->toArray(), [
                    'avatar_url' => $user->avatar_url
                ]),
                'message' => 'Profile updated successfully'
            ]);
        } catch (\Exception $e) {
            Log::error('Profile update error:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'message' => 'Failed to update profile',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function changePassword(Request $request)
    {
        try {
            $request->validate([
                'current_password' => ['required', 'current_password'],
                'password' => ['required', Password::defaults(), 'confirmed'],
            ]);

            $request->user()->update([
                'password' => Hash::make($request->password)
            ]);

            return response()->json(['message' => 'Password changed successfully']);
        } catch (\Exception $e) {
            Log::error('Password change error:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'message' => 'Failed to change password',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

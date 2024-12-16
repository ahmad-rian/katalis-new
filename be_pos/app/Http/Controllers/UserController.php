<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class UserController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:admin']);
    }

    public function index()
    {
        try {
            $users = User::with('roles')->paginate(10);
            return view('users.index', compact('users'));
        } catch (\Exception $e) {
            Log::error('Error in user index: ' . $e->getMessage());
            return back()->with('error', 'Unable to load users list.');
        }
    }

    public function create()
    {
        try {
            $roles = Role::all();
            return view('users.create', compact('roles'));
        } catch (\Exception $e) {
            Log::error('Error in user create: ' . $e->getMessage());
            return back()->with('error', 'Unable to load create form.');
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => ['required', 'string', 'max:255'],
                'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
                'password' => ['required', 'string', 'min:8', 'confirmed'],
                'role' => ['required', 'exists:roles,name']
            ]);

            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
            ]);

            $user->assignRole($validated['role']);

            return redirect()->route('users.index')
                ->with('success', 'User created successfully.');
        } catch (\Exception $e) {
            Log::error('Error creating user: ' . $e->getMessage());
            return back()->withInput()
                ->with('error', 'Failed to create user.');
        }
    }

    public function edit(User $user)
    {
        try {
            $roles = Role::all();
            return view('users.edit', compact('user', 'roles'));
        } catch (\Exception $e) {
            Log::error('Error in user edit: ' . $e->getMessage());
            return back()->with('error', 'Unable to load edit form.');
        }
    }

    public function update(Request $request, User $user)
    {
        try {
            $validated = $request->validate([
                'name' => ['required', 'string', 'max:255'],
                'email' => ['required', 'string', 'email', 'max:255', 'unique:users,email,' . $user->id],
                'role' => ['required', 'exists:roles,name']
            ]);

            $user->update([
                'name' => $validated['name'],
                'email' => $validated['email'],
            ]);

            if ($request->filled('password')) {
                $request->validate([
                    'password' => ['required', 'string', 'min:8', 'confirmed'],
                ]);

                $user->update([
                    'password' => Hash::make($request->password),
                ]);
            }

            $user->syncRoles([$validated['role']]);

            return redirect()->route('users.index')
                ->with('success', 'User updated successfully.');
        } catch (\Exception $e) {
            Log::error('Error updating user: ' . $e->getMessage());
            return back()->withInput()
                ->with('error', 'Failed to update user.');
        }
    }

    public function destroy(User $user)
    {
        try {
            if (auth()->id() === $user->id) {
                return back()->with('error', 'You cannot delete yourself.');
            }

            $user->delete();

            return redirect()->route('users.index')
                ->with('success', 'User deleted successfully.');
        } catch (\Exception $e) {
            Log::error('Error deleting user: ' . $e->getMessage());
            return back()->with('error', 'Failed to delete user.');
        }
    }
}

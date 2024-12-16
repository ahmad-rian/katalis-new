<x-app-layout>
    <div class="min-h-screen bg-gray-50/50 p-8">
        <div class="max-w-7xl mx-auto">
            {{-- Header Section --}}
            <div class="mb-8">
                <h1 class="text-2xl font-semibold text-gray-900">{{ __('Dashboard') }}</h1>
                <p class="mt-1 text-sm text-gray-500">
                    @if (auth()->user()->hasRole('admin'))
                        Manage and monitor your system from here
                    @elseif (auth()->user()->hasRole('operator'))
                        View and manage operations
                    @else
                        Welcome to your dashboard
                    @endif
                </p>
            </div>

            {{-- Welcome Card --}}
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden mb-6">
                <div class="p-6">
                    <div class="flex items-center">
                        <div
                            class="h-12 w-12 rounded-xl bg-gradient-to-r from-primary-600 to-primary-700 flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                @if (auth()->user()->hasRole('admin'))
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                                @elseif (auth()->user()->hasRole('operator'))
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                                @else
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                @endif
                            </svg>
                        </div>
                        <div class="ml-4">
                            <h2 class="text-lg font-medium text-gray-900">
                                Welcome back, {{ auth()->user()->name }}!
                            </h2>
                            <p class="text-sm text-gray-500">
                                You are logged in as {{ ucfirst(auth()->user()->roles->first()->name ?? 'User') }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            {{-- Quick Actions --}}
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                @if (auth()->user()->hasRole('admin'))
                    {{-- Admin Actions --}}
                    <a href="{{ route('users.index') }}"
                        class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 hover:border-primary-500/20 hover:shadow-md transition-all duration-200">
                        <div class="flex items-center">
                            <div class="h-10 w-10 rounded-xl bg-primary-50 flex items-center justify-center">
                                <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                                </svg>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-sm font-medium text-gray-900">User Management</h3>
                                <p class="text-sm text-gray-500">Manage system users and roles</p>
                            </div>
                        </div>
                    </a>

                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center">
                            <div class="h-10 w-10 rounded-xl bg-green-50 flex items-center justify-center">
                                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                </svg>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-sm font-medium text-gray-900">System Stats</h3>
                                <p class="text-sm text-gray-500">View system statistics and metrics</p>
                            </div>
                        </div>
                    </div>
                @endif

                {{-- Common Actions for All Users --}}
                <a href="{{ route('profile.edit') }}"
                    class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 hover:border-primary-500/20 hover:shadow-md transition-all duration-200">
                    <div class="flex items-center">
                        <div class="h-10 w-10 rounded-xl bg-blue-50 flex items-center justify-center">
                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="ml-4">
                            <h3 class="text-sm font-medium text-gray-900">Profile Settings</h3>
                            <p class="text-sm text-gray-500">Update your account preferences</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</x-app-layout>

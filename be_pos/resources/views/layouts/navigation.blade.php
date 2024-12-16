<nav x-data="{ open: false }" class="sidebar">
    <!-- Brand Section -->
    <div class="sidebar-brand">
        <a href="{{ route('dashboard') }}" class="flex items-center">
            <span class="sidebar-brand-text">Katalis</span>
        </a>
    </div>

    <!-- Navigation Links -->
    <div class="sidebar-nav">
        <!-- Main Navigation -->
        <div class="nav-section">
            <!-- Dashboard Link -->
            <a href="{{ route('dashboard') }}"
                class="nav-link group {{ request()->routeIs('dashboard') ? 'nav-link-active' : 'nav-link-inactive' }}">
                <svg class="nav-icon {{ request()->routeIs('dashboard') ? 'nav-icon-active' : 'nav-icon-inactive group-hover:text-gray-500' }}"
                    viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                </svg>
                <span>Dashboard</span>
            </a>

            <!-- Members Management Link -->
            <a href="{{ route('members.index') }}"
                class="nav-link group {{ request()->routeIs('members.*') ? 'nav-link-active' : 'nav-link-inactive' }}">
                <svg class="nav-icon {{ request()->routeIs('members.*') ? 'nav-icon-active' : 'nav-icon-inactive group-hover:text-gray-500' }}"
                    viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                <span>Members Management</span>
            </a>

            <!-- Events Link -->
            <a href="{{ route('events.index') }}"
                class="nav-link group {{ request()->routeIs('events.*') ? 'nav-link-active' : 'nav-link-inactive' }}">
                <svg class="nav-icon {{ request()->routeIs('events.*') ? 'nav-icon-active' : 'nav-icon-inactive group-hover:text-gray-500' }}"
                    viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M8 7V3a1 1 0 011-1h6a1 1 0 011 1v4m-9 0h10m-6 4h2m-2 4h2m-7 0a2 2 0 002 2h6a2 2 0 002-2m-10 0H5a2 2 0 01-2-2V7a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-2" />
                </svg>
                <span>Events</span>
            </a>

            @auth
                @if (auth()->user()->hasRole('admin'))
                    <!-- Users Management Link -->
                    <a href="{{ route('users.index') }}"
                        class="nav-link group {{ request()->routeIs('users.*') ? 'nav-link-active' : 'nav-link-inactive' }}">
                        <svg class="nav-icon {{ request()->routeIs('users.*') ? 'nav-icon-active' : 'nav-icon-inactive group-hover:text-gray-500' }}"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                        </svg>
                        <span>Users Management</span>
                    </a>
                @endif
            @endauth
        </div>

        <!-- User Profile Section -->
        @auth
            <div class="profile-section">
                <div class="p-4">
                    <div x-data="{ isOpen: false }" class="relative">
                        <button @click="isOpen = !isOpen" @click.away="isOpen = false" class="profile-button">
                            @if (Auth::user()->avatar)
                                <img src="{{ Auth::user()->avatar_url }}" alt="{{ Auth::user()->name }}"
                                    class="profile-avatar object-cover">
                            @else
                                <div class="profile-avatar">
                                    {{ substr(Auth::user()->name, 0, 1) }}
                                </div>
                            @endif
                            <div class="profile-info">
                                <p class="profile-name">{{ Auth::user()->name }}</p>
                                <p class="profile-email">{{ Auth::user()->email }}</p>
                            </div>
                            <svg class="ml-2 h-5 w-5 text-gray-400 transform transition-transform duration-200"
                                :class="{ 'rotate-180': isOpen }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                            </svg>
                        </button>

                        <!-- Dropdown Menu -->
                        <div x-show="isOpen" x-transition:enter="transition ease-out duration-200"
                            x-transition:enter-start="opacity-0 transform scale-95"
                            x-transition:enter-end="opacity-100 transform scale-100"
                            x-transition:leave="transition ease-in duration-75"
                            x-transition:leave-start="opacity-100 transform scale-100"
                            x-transition:leave-end="opacity-0 transform scale-95" class="profile-dropdown"
                            style="display: none;">
                            <!-- Profile Settings -->
                            <a href="{{ route('profile.edit') }}" class="dropdown-item">
                                <svg class="dropdown-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                Profile Settings
                            </a>

                            <!-- Sign Out -->
                            <form method="POST" action="{{ route('logout') }}" class="w-full">
                                @csrf
                                <button type="submit" class="dropdown-item">
                                    <svg class="dropdown-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                    </svg>
                                    Sign Out
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        @endauth
    </div>
</nav>

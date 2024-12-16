<x-app-layout>
    <div class="min-h-screen bg-gray-50/50 p-8">
        <div class="max-w-7xl mx-auto">
            {{-- Header Section --}}
            <div class="mb-8 flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold text-gray-900">{{ __('Event Management') }}</h1>
                    <p class="mt-1 text-sm text-gray-500">Manage your organization events</p>
                </div>
                <a href="{{ route('events.create') }}"
                    class="inline-flex items-center px-4 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all duration-200 shadow-sm">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Event
                </a>
            </div>

            {{-- Success Message --}}
            @if (session('success'))
                <div class="mb-6 p-4 bg-green-50 rounded-xl border border-green-100">
                    <div class="flex">
                        <svg class="w-5 h-5 text-green-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" />
                        </svg>
                        <p class="ml-3 text-sm text-green-700">{{ session('success') }}</p>
                    </div>
                </div>
            @endif

            {{-- Events Table --}}
            <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-100">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50/50">
                        <tr>
                            <th class="px-6 py-3.5 text-left text-xs font-medium text-gray-500 uppercase">Event Picture
                            </th>
                            <th class="px-6 py-3.5 text-left text-xs font-medium text-gray-500 uppercase">Event Name
                            </th>
                            <th class="px-6 py-3.5 text-left text-xs font-medium text-gray-500 uppercase">Type</th>
                            <th class="px-6 py-3.5 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                        @foreach ($events as $event)
                            <tr class="hover:bg-gray-50/50 transition-colors duration-200">
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    @if ($event->gambar)
                                        <img src="{{ asset('storage/' . $event->gambar) }}"
                                            alt="{{ $event->nama_event }}" class="w-16 h-16 object-cover rounded-md">
                                    @else
                                        <span>No Image</span>
                                    @endif
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $event->nama_event }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $event->jenis }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <div class="flex items-center space-x-4">
                                        <a href="{{ route('events.edit', $event) }}"
                                            class="text-gray-600 hover:text-primary-600 transition-colors duration-200">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                            </svg>
                                        </a>
                                        <form action="{{ route('events.destroy', $event) }}" method="POST"
                                            class="inline-block">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit"
                                                class="text-gray-600 hover:text-red-600 transition-colors duration-200"
                                                onclick="return confirm('Are you sure you want to delete this event?')">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</x-app-layout>

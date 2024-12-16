<x-app-layout>
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-4">Edit Event</h1>
        <form method="POST" action="{{ route('events.update', $event) }}" enctype="multipart/form-data">
            @csrf
            @method('PUT')

            <div class="mb-4">
                <label for="nama_event" class="block font-medium text-gray-700">Nama Event:</label>
                <input type="text" id="nama_event" name="nama_event"
                    value="{{ old('nama_event', $event->nama_event) }}" required
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                @error('nama_event')
                    <p class="text-red-500 text-sm mt-2">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                <label for="deskripsi" class="block font-medium text-gray-700">Deskripsi:</label>
                <textarea id="deskripsi" name="deskripsi" rows="4" required
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">{{ old('deskripsi', $event->deskripsi) }}</textarea>
                @error('deskripsi')
                    <p class="text-red-500 text-sm mt-2">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                <label for="jenis" class="block font-medium text-gray-700">Jenis:</label>
                <input type="text" id="jenis" name="jenis" value="{{ old('jenis', $event->jenis) }}" required
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                @error('jenis')
                    <p class="text-red-500 text-sm mt-2">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-4">
                <label for="gambar" class="block font-medium text-gray-700">Gambar:</label>
                <input type="file" id="gambar" name="gambar"
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                @if ($event->gambar)
                    <img src="{{ Storage::url($event->gambar) }}" alt="Gambar" class="mt-4 w-32 h-32 rounded-md">
                @endif
                @error('gambar')
                    <p class="text-red-500 text-sm mt-2">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex items-center gap-4">
                <button type="submit"
                    class="bg-blue-500 text-white px-4 py-2 rounded-md shadow hover:bg-blue-600">Update Event</button>
                <a href="{{ route('events.index') }}" class="text-gray-500 hover:underline">Cancel</a>
            </div>
        </form>
    </div>
</x-app-layout>

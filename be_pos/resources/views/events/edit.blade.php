<x-app-layout>
    <div class="min-h-screen bg-gray-50/50 p-8">
        <div class="max-w-2xl mx-auto">
            <div class="mb-8">
                <h1 class="text-2xl font-semibold text-gray-900">{{ __('Edit Event') }}</h1>
                <p class="mt-1 text-sm text-gray-500">Update event information</p>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <form method="POST" action="{{ route('events.update', $event) }}" class="p-6 space-y-6"
                    enctype="multipart/form-data">
                    @csrf
                    @method('PUT')

                    <div class="space-y-6">
                        {{-- Nama Event --}}
                        <div>
                            <x-input-label for="nama_event" :value="__('Nama Event')" />
                            <x-text-input id="nama_event" name="nama_event" type="text"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                :value="old('nama_event', $event->nama_event)" required />
                            <x-input-error class="mt-2" :messages="$errors->get('nama_event')" />
                        </div>

                        {{-- Deskripsi --}}
                        <div>
                            <x-input-label for="deskripsi" :value="__('Deskripsi')" />
                            <textarea id="deskripsi" name="deskripsi" rows="4"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                required>{{ old('deskripsi', $event->deskripsi) }}</textarea>
                            <x-input-error class="mt-2" :messages="$errors->get('deskripsi')" />
                        </div>

                        {{-- Jenis --}}
                        <div>
                            <x-input-label for="jenis" :value="__('Jenis')" />
                            <select name="jenis" id="jenis"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                required>
                                <option value="">Pilih jenis</option>
                                <option value="Info Kegiatan"
                                    {{ old('jenis', $event->jenis) == 'Info Kegiatan' ? 'selected' : '' }}>
                                    Info Kegiatan
                                </option>
                                <option value="Info Lomba"
                                    {{ old('jenis', $event->jenis) == 'Info Lomba' ? 'selected' : '' }}>
                                    Info Lomba
                                </option>
                                <option value="Info Beasiswa"
                                    {{ old('jenis', $event->jenis) == 'Info Beasiswa' ? 'selected' : '' }}>
                                    Info Beasiswa
                                </option>
                            </select>
                            <x-input-error class="mt-2" :messages="$errors->get('jenis')" />
                        </div>

                        {{-- Gambar --}}
                        <div>
                            <x-input-label for="gambar" :value="__('Gambar')" />
                            <input id="gambar" name="gambar" type="file"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                accept="image/*" />
                            @if ($event->gambar)
                                <div class="mt-2">
                                    <img src="{{ Storage::url($event->gambar) }}" alt="Current Event Image"
                                        class="h-32 w-32 object-cover rounded-xl border border-gray-200">
                                </div>
                            @endif
                            <x-input-error class="mt-2" :messages="$errors->get('gambar')" />
                        </div>
                    </div>

                    <div class="flex items-center gap-4 pt-4 border-t border-gray-100">
                        <button type="submit"
                            class="px-4 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all duration-200 shadow-sm">
                            {{ __('Update Event') }}
                        </button>
                        <a href="{{ route('events.index') }}"
                            class="px-4 py-2.5 bg-white text-gray-700 rounded-xl hover:bg-gray-50 transition-all duration-200 border border-gray-200">
                            {{ __('Cancel') }}
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>

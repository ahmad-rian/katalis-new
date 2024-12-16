<x-app-layout>
    <div class="min-h-screen bg-gray-50/50 p-8">
        <div class="max-w-2xl mx-auto">
            <div class="mb-8">
                <h1 class="text-2xl font-semibold text-gray-900">{{ __('Edit Member') }}</h1>
                <p class="mt-1 text-sm text-gray-500">Update member information</p>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <form method="POST" action="{{ route('members.update', $member) }}" class="p-6 space-y-6"
                    enctype="multipart/form-data">
                    @csrf
                    @method('PUT')

                    <!-- NIM -->
                    <div>
                        <x-input-label for="nim" :value="__('NIM')" />
                        <x-text-input id="nim" name="nim" type="text"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                            :value="old('nim', $member->nim)" required />
                        <x-input-error class="mt-2" :messages="$errors->get('nim')" />
                    </div>

                    <!-- Name -->
                    <div>
                        <x-input-label for="name" :value="__('Name')" />
                        <x-text-input id="name" name="name" type="text"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                            :value="old('name', $member->name)" required />
                        <x-input-error class="mt-2" :messages="$errors->get('name')" />
                    </div>

                    <!-- Batch Year -->
                    <div>
                        <x-input-label for="batch_year" :value="__('Batch Year')" />
                        <x-text-input id="batch_year" name="batch_year" type="number"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                            :value="old('batch_year', $member->batch_year)" required min="2000" max="{{ date('Y') }}" />
                        <x-input-error class="mt-2" :messages="$errors->get('batch_year')" />
                    </div>

                    {{-- Faculty --}}
                    <div>
                        <x-input-label for="faculty" :value="__('Faculty')" />
                        <select name="faculty" id="faculty"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20">
                            <option value="">Select Faculty</option>
                            <option value="Fakultas Teknik" {{ old('faculty') == 'Fakultas Teknik' ? 'selected' : '' }}>
                                Fakultas Teknik
                            </option>
                        </select>
                        <x-input-error class="mt-2" :messages="$errors->get('faculty')" />
                    </div>

                    {{-- Study Program --}}
                    <div>
                        <x-input-label for="study_program" :value="__('Study Program')" />
                        <select name="study_program" id="study_program"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20">
                            <option value="">Select Study Program</option>
                            <option value="Informatika" {{ old('study_program') == 'Informatika' ? 'selected' : '' }}>
                                Informatika
                            </option>
                            <option value="Teknik Komputer"
                                {{ old('study_program') == 'Teknik Komputer' ? 'selected' : '' }}>
                                Teknik Komputer
                            </option>
                            <!-- Add more study programs as needed -->
                        </select>
                        <x-input-error class="mt-2" :messages="$errors->get('study_program')" />
                    </div>

                    <!-- Profile Image -->
                    <div>
                        <x-input-label for="profile_image" :value="__('Profile Image')" />
                        <input id="profile_image" name="profile_image" type="file"
                            class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                            accept="image/*" />
                        <x-input-error class="mt-2" :messages="$errors->get('profile_image')" />

                        @if ($member->profile_image)
                            <div class="mt-4">
                                <p class="text-sm text-gray-500">{{ __('Current Profile Image') }}:</p>
                                <img src="{{ Storage::url($member->profile_image) }}" alt="{{ $member->name }}"
                                    class="mt-2 w-32 h-32 rounded-lg">
                            </div>
                        @endif
                    </div>

                    <!-- Submit Button -->
                    <div class="flex items-center gap-4 pt-4 border-t border-gray-100">
                        <button type="submit"
                            class="px-4 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all duration-200 shadow-sm">
                            {{ __('Update Member') }}
                        </button>
                        <a href="{{ route('members.index') }}"
                            class="px-4 py-2.5 bg-white text-gray-700 rounded-xl hover:bg-gray-50 transition-all duration-200 border border-gray-200">
                            {{ __('Cancel') }}
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>

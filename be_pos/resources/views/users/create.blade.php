<x-app-layout>
    <div class="min-h-screen bg-gray-50/50 p-8">
        <div class="max-w-2xl mx-auto">
            <div class="mb-8">
                <h1 class="text-2xl font-semibold text-gray-900">{{ __('Create User') }}</h1>
                <p class="mt-1 text-sm text-gray-500">Add a new user to the system</p>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <form method="POST" action="{{ route('users.store') }}" class="p-6 space-y-6">
                    @csrf

                    <div class="space-y-6">
                        <div>
                            <x-input-label for="name" :value="__('Name')" />
                            <x-text-input id="name" name="name" type="text"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                :value="old('name')" required autofocus />
                            <x-input-error class="mt-2" :messages="$errors->get('name')" />
                        </div>

                        <div>
                            <x-input-label for="email" :value="__('Email')" />
                            <x-text-input id="email" name="email" type="email"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                :value="old('email')" required />
                            <x-input-error class="mt-2" :messages="$errors->get('email')" />
                        </div>

                        <div>
                            <x-input-label for="password" :value="__('Password')" />
                            <x-text-input id="password" name="password" type="password"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                required />
                            <x-input-error class="mt-2" :messages="$errors->get('password')" />
                        </div>

                        <div>
                            <x-input-label for="password_confirmation" :value="__('Confirm Password')" />
                            <x-text-input id="password_confirmation" name="password_confirmation" type="password"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
                                required />
                        </div>

                        <div>
                            <x-input-label for="role" :value="__('Role')" />
                            <select name="role" id="role"
                                class="mt-1.5 block w-full rounded-xl border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20">
                                @foreach ($roles as $role)
                                    <option value="{{ $role->name }}"
                                        {{ old('role') == $role->name ? 'selected' : '' }}>
                                        {{ ucfirst($role->name) }}
                                    </option>
                                @endforeach
                            </select>
                            <x-input-error class="mt-2" :messages="$errors->get('role')" />
                        </div>
                    </div>

                    <div class="flex items-center gap-4 pt-4 border-t border-gray-100">
                        <button type="submit"
                            class="px-4 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all duration-200 shadow-sm">
                            {{ __('Create User') }}
                        </button>
                        <a href="{{ route('users.index') }}"
                            class="px-4 py-2.5 bg-white text-gray-700 rounded-xl hover:bg-gray-50 transition-all duration-200 border border-gray-200">
                            {{ __('Cancel') }}
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>

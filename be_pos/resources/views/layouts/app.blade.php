<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-full bg-gray-50">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">


    <meta name="google-signin-client_id"
        content="838898865124-ifr1pssrag31a6tfu0sest5lh2polm6v.apps.googleusercontent.com">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>

<body class="h-full">
    <div class="min-h-screen">
        @include('layouts.navigation')

        <!-- Main Content -->
        <div class="lg:pl-64">
            <main class="py-6">
                {{ $slot }}
            </main>
        </div>
    </div>
</body>

</html>

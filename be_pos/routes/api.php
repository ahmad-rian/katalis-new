<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\API\ProfileController;
use App\Http\Controllers\API\EventApiController;
use App\Http\Controllers\API\MemberApiController;
use App\Http\Controllers\MemberController;
use App\Http\Controllers\API\DashboardController;
use App\Http\Controllers\API\TransactionController;
use App\Http\Controllers\API\ProductController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
// Public routes
Route::controller(MemberApiController::class)->prefix('members')->group(function () {
    Route::get('/', 'index');
    Route::get('/search', 'search');
});


// Event public routes
Route::controller(EventApiController::class)->prefix('events')->group(function () {
    Route::get('/kegiatan', 'getKegiatan');
    Route::get('/lomba-beasiswa', 'getLombaBeasiswa');
});

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    // Profile routes
    Route::match(['post', 'put', 'patch'], '/profile/update', [ProfileController::class, 'update']);
    Route::post('/profile/change-password', [ProfileController::class, 'changePassword']);
    Route::post('/logout', [ProfileController::class, 'logout']);
});

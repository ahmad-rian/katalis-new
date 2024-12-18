<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\API\ProfileController;
use App\Http\Controllers\API\EventApiController;
use App\Http\Controllers\API\MemberApiController;
use App\Http\Controllers\API\PostController;
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

    // Post routes
    Route::controller(PostController::class)->prefix('posts')->group(function () {
        Route::get('/', 'index');
        Route::post('/', 'store');
        Route::get('/{post}', 'show');
        Route::put('/{post}', 'update');
        Route::delete('/{post}', 'destroy');

        // Interactions
        Route::post('/{post}/like', 'like');
        Route::delete('/{post}/like', 'unlike');
        Route::post('/{post}/repost', 'repost');

        // Comments
        Route::get('/{post}/comments', 'getComments');
        Route::post('/{post}/comments', 'addComment');
        Route::post('/{post}/comments', 'comment');
        Route::delete('/comments/{comment}', 'deleteComment');
        Route::post('/comments/{comment}/like', 'likeComment');
        Route::delete('/comments/{comment}/like', 'unlikeComment');
        Route::put('/posts/{post}', [PostController::class, 'update']);
        Route::delete('/posts/{post}', [PostController::class, 'destroy']);
    });
});

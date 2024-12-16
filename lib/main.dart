import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_con/controllers/member_controller.dart';
import 'package:pos_con/views/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_con/controllers/auth_controller.dart';
import 'package:pos_con/controllers/profile_controller.dart';
import 'package:pos_con/views/auth/login_view.dart';
import 'package:pos_con/views/auth/register_view.dart';
import 'package:pos_con/views/profile/profile_view.dart';
import 'package:pos_con/views/onboarding/onboarding_view.dart';
import 'package:pos_con/views/onboarding/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}

Future<void> initServices() async {
  try {
    print('Starting services initialization...');

    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await Get.putAsync(() async => prefs);
    print('SharedPreferences initialized');

    // Initialize controllers
    Get.put(AuthController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(MemberController(), permanent: true);
    print('Controllers initialized');

    print('All services initialized');
  } catch (e) {
    print('Error during services initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KATALIS',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: _getInitialRoute(),
      getPages: _buildGetPages(),
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  String _getInitialRoute() {
    final prefs = Get.find<SharedPreferences>();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final token = prefs.getString('token');

    if (!hasSeenOnboarding) return '/welcome';
    if (token != null) return '/dashboard';
    return '/login';
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1976D2),
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF1565C0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  List<GetPage> _buildGetPages() {
    return [
      GetPage(
        name: '/welcome',
        page: () => WelcomeScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/onboarding',
        page: () => const OnboardingScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/login',
        page: () => LoginView(),
        transition: Transition.fadeIn,
        middlewares: [NoAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.put(AuthController());
        }),
      ),
      GetPage(
        name: '/register',
        page: () => RegisterView(),
        transition: Transition.rightToLeft,
        middlewares: [NoAuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.put(AuthController());
        }),
      ),
      GetPage(
        name: '/dashboard',
        page: () => DashboardView(),
        transition: Transition.fadeIn,
        middlewares: [AuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.put(ProfileController());
        }),
      ),
      GetPage(
        name: '/profile',
        page: () => ProfileView(),
        transition: Transition.rightToLeft,
        middlewares: [AuthMiddleware()],
        binding: BindingsBuilder(() {
          Get.put(ProfileController());
        }),
      ),
    ];
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (AuthController.to.isLoggedIn) return null;
    return const RouteSettings(name: '/login');
  }
}

class NoAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final prefs = Get.find<SharedPreferences>();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      return const RouteSettings(name: '/welcome');
    }

    if (AuthController.to.isLoggedIn &&
        (route == '/login' || route == '/register')) {
      return const RouteSettings(name: '/dashboard');
    }

    return null;
  }
}

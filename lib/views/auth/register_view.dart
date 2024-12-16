import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  // Add reactive booleans to track password visibility
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isConfirmPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
            ],
            stops: [0.2, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/hmif.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Title Section
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ).createShader(bounds),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Join HMIF Super Apps',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 48),

                  // Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person, color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible.value,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.lock, color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                _isPasswordVisible.value =
                                    !_isPasswordVisible.value;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      )),
                  SizedBox(height: 16),

                  // Confirm Password Field
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: passwordConfirmController,
                          obscureText: !_isConfirmPasswordVisible.value,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                _isConfirmPasswordVisible.value =
                                    !_isConfirmPasswordVisible.value;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      )),
                  SizedBox(height: 24),

                  // Error Message
                  Obx(() => controller.errorMessage.value.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(color: Colors.red[300]),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox()),

                  // Register Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF5F5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            passwordConfirmController.text.isEmpty) {
                          controller.errorMessage.value =
                              'All fields are required';
                          return;
                        }
                        if (passwordController.text !=
                            passwordConfirmController.text) {
                          controller.errorMessage.value =
                              'Passwords do not match';
                          return;
                        }

                        final success = await controller.register(
                          username: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          passwordConfirmation: passwordConfirmController.text,
                        );

                        if (success) {
                          Get.snackbar(
                            'Success',
                            'Registration successful! Please login.',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          Get.offAllNamed('/login');
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Obx(() => controller.isLoading.value
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1565C0)),
                              ),
                            )
                          : Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF424242),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            )),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: Text(
                          'Login here',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

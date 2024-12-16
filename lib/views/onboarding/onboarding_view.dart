import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pos_con/views/auth/login_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/bg1.jpg',
      'title': 'Welcome to HMIF Super Apps',
      'subtitle': 'Your one-stop solution for HMIF community needs',
    },
    {
      'image': 'assets/images/bg2.jpg',
      'title': 'Student Data Search',
      'subtitle': 'Easily search student data and information using NIM',
    },
    {
      'image': 'assets/images/bg3.jpg',
      'title': 'Real-time Updates',
      'subtitle': 'Stay connected with latest updates and community features',
    },
  ];

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 800),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Background Image with Gradient Overlay
                  Positioned.fill(
                    child: Image.asset(
                      onboardingData[index]['image']!,
                      fit: BoxFit.cover,
                    ).animate(
                      effects: [
                        FadeEffect(duration: 800.ms),
                        BlurEffect(
                            begin: Offset(10.0, 10.0), end: Offset(0.0, 0.0)),
                        ScaleEffect(
                            begin: Offset(1.1, 1.1), end: Offset(1.0, 1.0)),
                      ],
                    ),
                  ),

                  // Dark Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Content Container
                          Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 25,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  onboardingData[index]['title']!,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  onboardingData[index]['subtitle']!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ).animate(
                            effects: [
                              FadeEffect(duration: 600.ms, delay: 400.ms),
                              SlideEffect(begin: Offset(0, 0.2)),
                            ],
                          ),

                          SizedBox(height: 40),

                          // Page Indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingData.length,
                              (i) => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                width: i == _currentPage ? 32 : 12,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: i == _currentPage
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ).animate(
                            effects: [
                              FadeEffect(duration: 600.ms, delay: 600.ms),
                            ],
                          ),

                          SizedBox(height: 40),

                          // Next/Get Started Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _goToNextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                _currentPage == onboardingData.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ).animate(
                              effects: [
                                FadeEffect(duration: 600.ms, delay: 800.ms),
                                SlideEffect(begin: Offset(0, 0.2)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

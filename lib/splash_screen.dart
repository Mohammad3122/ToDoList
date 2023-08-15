import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'todo_feature/screens/show_todo_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String screenId = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  goHome() async {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = _controller.drive(Tween(begin: 0.0, end: 1.0));
    _controller.forward().then(
          (value) =>
              Navigator.pushReplacementNamed(context, ShowTodoScreen.screenId),
        );
  }

  @override
  void initState() {
    super.initState();
    goHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[400],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Lottie.asset(
                'assets/lottie/splash_screen.json',
                height: 500,
                width: 500,
                fit: BoxFit.contain,
                repeat: false,
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: const Text(
              'اپلیکیشن انجام وظایف',
              style: TextStyle(
                fontFamily: 'nasim',
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

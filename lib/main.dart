import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/database_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Check if the user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Provide a default value

  runApp(MyApp(isLoggedIn: isLoggedIn));
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      // Navigate based on login state
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/database': (context) => const DatabaseScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page not found!'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';
import 'package:load_system/screens/admin_screen.dart';
import 'package:load_system/screens/sign_up_screen.dart';
import 'package:load_system/screens/splash_screen.dart';
import 'package:load_system/screens/user_screen.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupIsar();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load System',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash-screen',
      routes: {
        '/splash-screen': (context) => const SplashScreen(),
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
        '/admin': (context) => AdminScreen(),
        '/user': (context) => UserScreen(user: User()),
      },
    );
  }
}

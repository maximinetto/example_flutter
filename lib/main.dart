import 'package:example_flutter/home.dart';
import 'package:example_flutter/login.dart';
import 'package:example_flutter/services/auth_service.dart';
import 'package:example_flutter/view_models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthService())..load(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        auth.userActivityDetected();
      },
      child: MaterialApp(
        title: "Super App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (auth.isAuthenticated) {
              return const HomeView();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}

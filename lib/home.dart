import 'package:example_flutter/view_models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    await auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "logout") await _logout(context);
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: "logout", child: Text("Logout")),
                ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
          Center(child: Text("Home")),
        ],
      ),
    );
  }
}

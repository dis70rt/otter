import 'package:flutter/material.dart';
import 'package:otter/services/login_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "O T T E R",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => userLogout(), 
          icon: const Icon(Icons.logout_outlined)),
      ),
      body: const Center(
        child: Text("HOMEPAGE"),
      ),
    );
  }
}

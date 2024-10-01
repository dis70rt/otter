import 'package:flutter/material.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder:(context, authProvider, child) =>  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "O T T E R",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () => authProvider.logout(context),
            icon: const Icon(Icons.logout_outlined)),
        ),
        body: const Center(
          child: Text("HOMEPAGE"),
        ),
      ),
    );
  }
}

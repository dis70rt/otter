import 'package:flutter/material.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:otter/services/database_provider.dart';
import 'package:otter/ui/screens/settings_screen.dart';
import 'package:otter/ui/widgets/appbar.dart';
import 'package:otter/ui/widgets/Company/company_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dbProvider = Provider.of<FireStoreProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(authProvider, context, dbProvider, _selectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [DashboardScreen(), CompanyWidget(), SettingsScreen()],
      ),
      bottomNavigationBar:
          buildBottomNavigationBar(_onItemTapped, _selectedIndex),
    );
  }
}

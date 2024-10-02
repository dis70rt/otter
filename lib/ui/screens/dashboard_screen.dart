import 'package:flutter/material.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:otter/ui/widgets/Dashboard/dashboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(authProvider.user?.photoURL ??
                  "https://i.imgur.com/WxNkK7J.png"),
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ),
        // backgroundColor: Colors.grey.shade900,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: const Icon(Icons.logout_outlined), onPressed: () {}),
          )
        ],
        centerTitle: true,
        title: const Text(
          "OTTER",
          style: TextStyle(
              color: Colors.blueAccent,
              letterSpacing: 4,
              fontWeight: FontWeight.w900),
        ),

        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 80),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 12),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: const Color.fromRGBO(9, 9, 20, 1),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, color: Colors.transparent)),
                ),
              ),
            )),
      ),
      body: const Center(child: DashboardWidget())
    );
  }
}

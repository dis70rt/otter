import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const Text(
                "Account & Security",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midBlue,
                ),
              ),
              const SizedBox(height: 20),
              _buildUserInfoSection(auth),
              const Divider(),
              _buildSecurityOptions(auth, context),
              const Divider(),
              _buildListTile(
                  icon: Icons.exit_to_app,
                  title: "Sign Out",
                  onTap: () => auth.logout(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            auth.user?.photoURL ?? "https://i.imgur.com/WxNkK7J.png",
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.user?.displayName ?? "No Name",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                auth.user?.email ?? "No Email",
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Navigate to edit profile screen
          },
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSecurityOptions(AuthProvider auth, BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.lock,
          title: "Change Password",
          onTap: () {
            // auth.user?.updatePassword("Saikat");
          },
        ),
        _buildListTile(
          icon: Icons.security,
          title: "Two-Factor Authentication",
          onTap: () {
            // Navigate to 2FA settings screen
          },
        ),
        _buildListTile(
          icon: Icons.delete,
          title: "Delete Account",
          onTap: () {
            _showDeleteAccountDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Handle account deletion logic
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

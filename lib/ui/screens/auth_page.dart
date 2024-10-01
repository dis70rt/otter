import 'package:flutter/material.dart';
import 'package:otter/ui/screens/add_phone.dart';
import 'package:otter/ui/screens/auth_screen.dart';
import 'package:otter/ui/widgets/verify_email.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if(authProvider.user == null) {
          return const AuthScreen();
        } else if (authProvider.isEmailVerified) {
          return const AddPhone();
        } else {
          return const VerifyEmail();
        }
      }
    );
  }
}

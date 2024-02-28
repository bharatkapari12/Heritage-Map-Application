import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';


class AuthScreen extends ConsumerWidget {
  static const routeName = 'AuthScreen';
  AuthScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (auth.currentUser != null) {
      ref.read(navIndexProvider.notifier).state = 0;
      return NavigationScreen();
    }
    return const LoginScreen();
  }
}

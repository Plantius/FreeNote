import 'package:flutter/material.dart';
import 'package:free_note/providers/auth_provider.dart';
import 'package:free_note/event_logger.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Column(
        children: [
          Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: _submitLogin, 
                  child: const Text('Log In'),
                )
              ],
            )
          ),
          IconButton(
            onPressed: _debugLogin, 
            icon: const Icon(Icons.auto_awesome)
          ),
        ],
      ) 
    );
  }

  void _submitLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    bool success = await context.read<AuthProvider>().signIn(email, password);
    
    if (success) {
      if (mounted) {
        context.go('/');
      }
    }
  }

  void _debugLogin() async {
    final success = await context.read<AuthProvider>().signIn(
      'test@example.com',
      'supersecret',
    );

    if (success) {
      logger.i('Successfully logged into development account');

      if (mounted) {
        context.go('/');
      }
    } else {
      logger.e('Logging into development account failed');
    }
  }
}

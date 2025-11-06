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

  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   _isSignUp
                //     ? 'Sign Up'
                //     : 'Sign In',
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),

                _buildForm(context, auth),

                SizedBox(
                  height: 20,
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  }, 
                  child: _isSignUp 
                    ? const Text('Have an account? Sign in')
                    : const Text('New here? Sign up')
                ),

                SizedBox(
                  height: 20,
                ),

                IconButton(
                  onPressed: () => _debugLogin(auth),
                  icon: const Icon(Icons.auto_awesome)
                ),
              ],
            ),
          ),
        ),
      ) 
    );
  }

  Widget _buildForm(BuildContext context, AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address'
            ),
            validator: _emailValidator,
          ),

          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password'
            ),
            validator: _passwordValidator,
          ),

          SizedBox(
            height: 20,
          ),

          ElevatedButton(
            onPressed: auth.loading ? null : _submitLogin, 
            child: auth.loading 
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
              : Text(
                _isSignUp
                  ? 'Register'
                  : 'Log In'
                )
          )
        ],
      )
    );
  }

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    AuthProvider auth = context.read<AuthProvider>();

    late bool success;
    if (_isSignUp) {
      success = await auth.signUp(email, password);
    } else {
      success = await auth.signIn(email, password);
    }

    print('Success? $success Mounted? $mounted');

    if (success) {
      if (mounted) {
        context.go('/');
      }
    } else {
      if (mounted) {
        _loginError(
          _isSignUp
            ? "Sign up failed: ${auth.error}"
            : "Login failed: ${auth.error}"
        );
      }
    }
  }

  void _debugLogin(AuthProvider auth) async {
    final success = await auth.signIn(
      'test@example.com',
      'supersecret',
    );

    if (success) {
      logger.i('Successfully logged into development account');

      if (mounted) {
        context.go('/');
      }
    } else {
      logger.e('Debug login failed: ${auth.error}');
    }
  }

  void _loginError(String error) {
    final snackBar = SnackBar(
      content: Text(
        error,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black.withValues(alpha: 0.5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }

    final valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);
    
    if (!valid) {
      return "Please enter a valid email address";
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    return null;
  }
}

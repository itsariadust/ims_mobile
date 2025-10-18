import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/views/viewmodels/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child:
                Text(
                  style: Theme.of(context).textTheme.headlineLarge,
                  'Login to the System'
                ),
              ),
              SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: usernameError,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: passwordError,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => handleLogin(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                child: Text(
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  'Login'
                )
              )
            ],
          ),
        )
      )
    );
  }

  void handleLogin() async {
    setState(() {
      usernameError = usernameController.text.isEmpty ? 'Username cannot be empty' : null;
      passwordError = passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    });

    if (usernameError != null || passwordError != null) return;

    try {
      // Use local state (dialog) for loading
      if (mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }

      // authViewModelProvider's state is NOT set to AsyncLoading() here anymore.
      await ref.read(authViewModelProvider.notifier).login(usernameController.text, passwordController.text);
    } catch (e) {
      setState(() {
        usernameError = 'Invalid username or password';
        passwordError = 'Invalid username or password';
      });
    } finally {
      if (mounted) Navigator.of(context).pop(); // close loading dialog
    }
  }
}

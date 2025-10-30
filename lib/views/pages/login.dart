import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/viewmodels/auth/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorText;

  Future<void> _onLogin() async {
    setState(() {
      errorText = null;
    });

    final result = await ref.read(authViewModelProvider.notifier).login(
      emailController.text,
      passwordController.text,
    );

    if (result is Success) {
      if (mounted) context.go('/home');
    } else if (result is FailureResult) {
      final failure = result.toString();
      setState(() {
        errorText = failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: errorText != null ? '' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: errorText != null ? '' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: isLoading ? null : _onLogin,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        )
      )
    );
  }
}
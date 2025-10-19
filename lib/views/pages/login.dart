import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/viewmodels/auth/auth_viewmodel.dart';

final emailControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final passwordControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);

    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

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
                  errorText: authState.emailError,
                  border: const OutlineInputBorder(),
                ),
                  onChanged: viewModel.updateEmail
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: authState.passwordError,
                  border: const OutlineInputBorder(),
                ),
                  onChanged: viewModel.updatePassword
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: authState.isLoading ? null : viewModel.login,
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary
                ),
                child: authState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Login', style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary
                  )
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
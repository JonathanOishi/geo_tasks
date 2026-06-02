import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthenticationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: authVm.isLoading
              ? null
              : () async {
                  final navigator = Navigator.of(context);
                  await authVm.logout();
                  navigator.pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                },
          child: authVm.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Sair da conta'),
        ),
      ),
    );
  }
}

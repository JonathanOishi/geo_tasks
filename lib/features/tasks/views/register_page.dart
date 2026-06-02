import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthenticationViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/logo_geo_tasks.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 185,
                          ),

                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Crie sua conta',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Bem-vindo! Por favor, preencha os campos abaixo para criar sua conta.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                CustomTextField(
                                  label: 'Nome',
                                  hintText: 'Digite seu nome',
                                  prefixIcon: Icons.person,
                                  controller: _nameController,
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'E-mail',
                                  hintText: 'example@example.com',
                                  prefixIcon: Icons.email,
                                  controller: _emailController,
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Senha',
                                  hintText: 'Digite sua senha',
                                  prefixIcon: Icons.lock,
                                  suffixIcon: Icons.visibility_off,
                                  controller: _passwordController,
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Confirmar Senha',
                                  hintText: 'Digite sua senha novamente',
                                  prefixIcon: Icons.lock,
                                  suffixIcon: Icons.visibility_off,
                                  controller: _confirmPasswordController,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: authVm.isLoading
                                      ? null
                                      : () async {
                                          final navigator = Navigator.of(
                                            context,
                                          );
                                          final messenger =
                                              ScaffoldMessenger.of(context);

                                          final userRegistered = await authVm
                                              .register(
                                                _nameController.text,
                                                _emailController.text,
                                                _passwordController.text,
                                                _confirmPasswordController.text,
                                              );

                                          if (userRegistered) {
                                            navigator.pushReplacementNamed(
                                              AppRoutes.home,
                                            );
                                          } else {
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  authVm.errorMessage ??
                                                      'Falha no cadastro.',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: authVm.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Registrar-se'),
                                ),
                                if (authVm.errorMessage != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    authVm.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Já tem uma conta?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.login,
                                        );
                                      },
                                      child: Text(
                                        'Faça login',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

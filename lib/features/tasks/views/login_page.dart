import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Bem-vindo de volta!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomTextField(
                                  label: 'E-mail',
                                  hintText: 'example@example.com',
                                  prefixIcon: Icons.email,
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Senha',
                                  hintText: 'Digite sua senha',
                                  prefixIcon: Icons.lock,
                                  suffixIcon: Icons.visibility_off,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text('Esqueci minha senha'),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed(AppRoutes.home);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Não tem uma conta?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed(AppRoutes.register);
                                      },
                                      child: Text('Registrar-se'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(color: AppColors.primary),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text('Ou continue com'),
                                    ),
                                    Expanded(
                                      child: Divider(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/google.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  label: ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFF4285F4),
                                          Color(0xFFEA4335),
                                          Color(0xFFFBBC05),
                                          Color(0xFF34A853),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      'Entrar com Google',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
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

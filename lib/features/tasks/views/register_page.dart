import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'E-mail',
                                  hintText: 'example@example.com',
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Senha',
                                  hintText: 'Digite sua senha',
                                ),
                                SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Confirmar Senha',
                                  hintText: 'Digite sua senha novamente',
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Text('Registrar-se'),
                                ),
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

import 'package:flutter/material.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5718),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone
                Image.asset(
                  'assets/images/lixeira.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 20),

                // Título
                const Text(
                  'Crie sua conta:',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RozhaOne',
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Nome
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Nome',
                  ),
                ),

                const SizedBox(height: 20),

                // E-mail
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),

                const SizedBox(height: 20),

                // Senha
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    hintText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirmar senha
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    hintText: 'Confirmar senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Botão Sign up
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      // lógica de cadastro
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF678E35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: const Text(
      'Sign up',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 16),

// Botão de voltar para login
TextButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text(
    'Já tem uma conta? Entrar',
    style: TextStyle(
      decoration: TextDecoration.underline,
      fontSize: 16,
      color: Colors.white,
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

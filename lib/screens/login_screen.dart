import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5718), // Fundo da tela
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/lixeira.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 20),

                // Título
                const Text(
                  'Login:',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RozhaOne',
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Campo de e-mail
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),

                const SizedBox(height: 20),

                // Campo de senha
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
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
                    hintText: 'Senha',
                  ),
                ),

                const SizedBox(height: 30),

                // Botão Entrar
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF678E35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: const Text(
      'Entrar',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 16),

// Botão de texto "Criar conta"
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  },
  child: const Text(
    'Criar conta',
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

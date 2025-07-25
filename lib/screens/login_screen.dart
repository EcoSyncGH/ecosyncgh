import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Image.asset('assets/images/lixeira.png', height: 100),
              const SizedBox(height: 16),
              const Text(
                'Login:',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'RozhaOne',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D5718)),
              ),
              const SizedBox(height: 24),
              _buildTextField(_emailController, 'E-mail', Icons.email),
              const SizedBox(height: 12),
              _buildTextField(_passwordController, 'Senha', Icons.lock,
                  isPassword: true,
                  obscure: _obscurePassword,
                  toggle: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      })),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF80B142),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text(
                  'É sua primeira vez? Clique aqui',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3D5718),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F5C8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: toggle,
                )
              : null,
        ),
      ),
    );
  }
}

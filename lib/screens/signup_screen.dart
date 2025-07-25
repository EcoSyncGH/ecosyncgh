import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Após criar conta, você pode salvar o nome no Firestore se quiser

      Navigator.pop(context); // Volta para tela de login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar conta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Image.asset('assets/images/lixeira.png', height: 100),
              const SizedBox(height: 16),
              const Text(
                'Crie sua conta:',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'RozhaOne',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D5718)),
              ),
              const SizedBox(height: 24),
              _buildTextField(_nameController, 'Nome', Icons.person),
              const SizedBox(height: 12),
              _buildTextField(_emailController, 'E-mail', Icons.email),
              const SizedBox(height: 12),
              _buildTextField(_passwordController, 'Senha', Icons.lock,
                  isPassword: true, obscure: _obscurePassword, toggle: () {
                setState(() => _obscurePassword = !_obscurePassword);
              }),
              const SizedBox(height: 12),
              _buildTextField(_confirmPasswordController, 'Confirmar Senha',
                  Icons.lock, isPassword: true, obscure: _obscureConfirmPassword, toggle: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF80B142),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
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

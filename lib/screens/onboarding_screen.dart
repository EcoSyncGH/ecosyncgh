import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "O que são Ecopontos?",
      "text":
          "São locais públicos onde você pode descartar corretamente resíduos recicláveis, eletroeletrônicos, móveis, entulhos e outros materiais, sem prejudicar o meio ambiente.",
    },
    {
      "title": "Qual nosso objetivo?",
      "text":
          "A EcoSync deseja poder direcionar você para a localização dos Ecopontos mais próximos, com a descrição de cada um.",
    },
    {
      "title": "Precisamos da sua localização",
      "text":
          "Nosso app utiliza a sua localização para oferecer uma experiência completa e personalizada. Com esse acesso, conseguimos mostrar informações relevantes perto de você e garantir que todos os recursos funcionem corretamente.",
      "privacy":
          "Não se preocupe — sua privacidade é importante para nós, e seus dados estarão sempre protegidos.",
    },
  ];

  Future<void> _requestLocation() async {
    final status = await Permission.location.status;

    if (!mounted) return;

    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.location.request();

      if (!mounted) return;

      if (result.isGranted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de localização negada.')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = onboardingData[index];
                  final isLast = index == onboardingData.length - 1;

                  return Padding(
  padding: const EdgeInsets.all(32.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (isLast)
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Image.asset(
            'assets/images/recycle.png',
            width: 122,
            height: 133,
          ),
        ),

      // Retângulo de fundo com textos
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF678E35), // cor do retângulo
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              page['title']!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'RozhaOne',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              page['text']!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            if (isLast && page.containsKey('privacy')) ...[
              const SizedBox(height: 25),
              Text(
                page['privacy']!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  ),
);

                },
              ),
            ),

if (_currentPage == onboardingData.length - 1)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _requestLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF80B142),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Indicadores de página
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index ? Colors.white : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão "Continuar" apenas na última página
            
          ],
        ),
      ),
    );
  }
}

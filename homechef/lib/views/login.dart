import 'package:flutter/material.dart';
import 'package:homechef/Widgets/textform.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF8E1), // Un color cálido, como un amarillo pálido
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/logo.png'),
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 40),
            const Text(
              'Bienvenido de nuevo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723), // Un tono marrón para un toque cálido
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingresa para continuar',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6D4C41), // Marrón claro
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomInput(
                controller: emailController,
                keyboardType: TextInputType.text,
                hintText: 'Correo electrónico',
                icon: Icons.email,
                type: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomInput(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Contraseña',
                icon: Icons.lock,
                obscure: true,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF6C00), // Naranja cálido
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Acción para recuperar contraseña
              },
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Color(0xFFEF6C00), // Naranja cálido
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

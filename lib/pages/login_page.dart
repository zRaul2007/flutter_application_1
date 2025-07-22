// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  // Função para lidar com o login via Google
  Future<void> _loginWithGoogle() async {
    // Mostra o indicador de carregamento
    setState(() {
      _isLoading = true;
    });

    // Acessa o serviço de autenticação
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signInWithGoogle();

    // Se o login falhar ou for cancelado pelo usuário
    if (user == null && mounted) {
      setState(() {
        _isLoading = false;
      });
      // Opcional: mostrar uma mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao tentar fazer login com o Google.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // Se o login for bem-sucedido, o `AuthWrapper` (configurado no main.dart)
    // irá automaticamente redirecionar para a tela principal.
    // Se o widget não estiver mais na tela, paramos o loading para evitar erros.
    else if (!mounted) {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Usamos um Padding para dar um respiro nas bordas da tela
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Alinha os itens no centro da tela
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Seção de Identidade Visual ---
              const Icon(Icons.pets, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Pet Monitor',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Sua coleira inteligente para pets',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 64),

              // --- Botão de Login ---
              // Se estiver carregando, mostra o CircularProgressIndicator.
              // Caso contrário, mostra o botão.
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ), // Ícone do Google
                      label: const Text(
                        'Entrar com Google',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: _loginWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Cor de fundo do botão
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

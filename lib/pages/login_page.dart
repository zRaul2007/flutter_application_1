import 'package:flutter/material.dart';
// Certifique-se de que o caminho de importação para a home_page.dart está correto
// para a estrutura do seu projeto.
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Apenas uma definição da função, com a lógica correta e simplificada.
  Future<void> _login() async {
    // 1. Valida o formulário. Se não for válido, não faz nada.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Atualiza o estado para mostrar o indicador de carregamento.
    setState(() {
      _isLoading = true;
    });

    // 3. Simula a espera por uma resposta da rede (2 segundos).
    await Future.delayed(const Duration(seconds: 2));

    // 4. Se o widget ainda estiver "montado" (visível), navega para a próxima tela.
    //    Esta verificação `mounted` é uma boa prática em funções assíncronas
    //    para evitar erros caso o usuário saia da tela durante o carregamento.
    if (!mounted) return;

    // 5. Usa o Navigator para substituir a tela atual pela HomePage.
    //    Isso significa que o usuário não pode usar o botão "voltar" para
    //    retornar à tela de login, o que é o comportamento desejado.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 80),
              const Icon(Icons.pets, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Pet Monitor',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Bem-vindo de volta!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Por favor, insira um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: const [
          // Podemos adicionar opções de configuração aqui no futuro.
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil do Usuário'),
            subtitle: Text('Editar informações da conta'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Notificações'),
            subtitle: Text('Gerenciar preferências de alerta'),
          ),
          ListTile(leading: Icon(Icons.logout), title: Text('Sair')),
        ],
      ),
    );
  }
}

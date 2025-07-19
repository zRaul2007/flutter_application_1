// lib/main.dart
import 'dart:io'; // NECESSÁRIO para usar 'Platform'
import 'package:flutter/foundation.dart'
    show kIsWeb; // NECESSÁRIO para usar 'kIsWeb'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // NECESSÁRIO para o banco de dados no desktop/web
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/main_screen.dart';
import 'package:flutter_application_1/providers/pet_provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Lógica de inicialização do banco de dados
  if (kIsWeb) {
    // Usa a "fábrica" de banco de dados específica para a web
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Usa a "fábrica" de banco de dados para desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Suas credenciais do Firebase
  const firebaseConfig = {
    'apiKey': "AIzaSyAR8oiNXJQ6StRQ1-1h-vzurp7zDR-tOY4",
    'authDomain': "pet-monitor-e0437.firebaseapp.com",
    'projectId': "pet-monitor-e0437",
    'storageBucket': "pet-monitor-e0437.appspot.com",
    'messagingSenderId': "903104501156",
    'appId': "1:903104501156:web:1b1d4e4ea9a8c3fdb69d31",
  };

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PetProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Monitor',
      debugShowCheckedModeBanner: false,

      // --- TEMA CLARO (LIGHT THEME) ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        // A propriedade 'cardTheme' espera um objeto do tipo 'CardThemeData'.
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),

      // --- TEMA ESCURO (DARK THEME) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        // --- CORREÇÃO AQUI TAMBÉM ---
        cardTheme: CardThemeData(
          // Alterado de CardTheme para CardThemeData
          color: Colors.grey[850],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

// Widget que gerencia o estado da autenticação e a navegação
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    // StreamBuilder ouve as mudanças no status do login em tempo real
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        // Enquanto verifica, mostra um spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tem dados, significa que o usuário está logado
        if (snapshot.hasData) {
          final petProvider = Provider.of<PetProvider>(context, listen: false);
          // Carrega os pets associados a este usuário do banco de dados
          petProvider.loadUserPets(snapshot.data!.uid);
          // Mostra a tela principal
          return const MainScreen();
        }

        // Se não tem dados, o usuário não está logado
        // Mostra a tela de login
        return const LoginPage();
      },
    );
  }
}

// A classe MeuApp é o widget principal da aplicação.
// Ela define o tema da aplicação e a página inicial, que é a AuthWrapper.

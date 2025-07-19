// lib/providers/pet_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/pet_models.dart';
import '../services/database_helper.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];
  List<Alert> _alerts = [];
  String? _currentUserId;
  Timer? _simulationTimer;

  PetProvider() {
    startSimulation();
  }

  // Getters
  List<Pet> get pets => [..._pets];
  List<Alert> get alerts {
    _alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return [..._alerts];
  }

  // Carrega os pets ao logar
  Future<void> loadUserPets(String userId) async {
    _currentUserId = userId;
    // Na web, a lista é gerenciada em memória. No mobile/desktop, carrega do DB.
    if (!kIsWeb) {
      _pets = await DatabaseHelper.instance.getPets(userId);
    }
    notifyListeners();
  }

  // Limpa os dados ao fazer logout
  void clearData() {
    _pets.clear();
    _alerts.clear();
    _currentUserId = null;
    notifyListeners();
  }

  // Adiciona um novo pet
  Future<void> addPet({
    required String name,
    required String breed,
    required Species species,
    required int age,
    File? avatarFile,
    required VitalThresholds thresholds,
  }) async {
    if (_currentUserId == null) return;

    final newPet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      breed: breed,
      species: species,
      age: age,
      avatarFile: avatarFile,
      ownerId: _currentUserId!,
      healthStatus: HealthStatus.unknown,
      thresholds: thresholds,
    );

    _pets.add(
      newPet,
    ); // Adiciona na lista em memória para feedback visual imediato
    notifyListeners();

    // Se não for web, também salva no banco de dados
    if (!kIsWeb) {
      await DatabaseHelper.instance.insertPet(newPet, _currentUserId!);
    }
  }

  // Atualiza um pet existente
  Future<void> updatePet(Pet updatedPet) async {
    final petIndex = _pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (petIndex >= 0) {
      _pets[petIndex] = updatedPet;
      notifyListeners();
    }

    if (!kIsWeb) {
      await DatabaseHelper.instance.updatePet(updatedPet);
    }
  }

  // Deleta um pet
  Future<void> deletePet(String petId) async {
    _pets.removeWhere((pet) => pet.id == petId);
    notifyListeners();

    if (!kIsWeb) {
      await DatabaseHelper.instance.deletePet(petId);
    }
  }

  // Reconhece um alerta
  void acknowledgeAlert(String alertId) {
    final alertIndex = _alerts.indexWhere((alert) => alert.id == alertId);
    if (alertIndex != -1) {
      final oldAlert = _alerts[alertIndex];
      _alerts[alertIndex] = Alert(
        id: oldAlert.id,
        petId: oldAlert.petId,
        petName: oldAlert.petName,
        timestamp: oldAlert.timestamp,
        message: oldAlert.message,
        severity: oldAlert.severity,
        acknowledged: true,
      );
      notifyListeners();
    }
  }

  // --- LÓGICA DE SIMULAÇÃO (Pode ser mantida para testes) ---
  void startSimulation() {
    if (_simulationTimer?.isActive ?? false) return;
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pets.isEmpty) return;
      for (int i = 0; i < _pets.length; i++) {
        _simulateVitalsForPet(i);
      }
      notifyListeners();
    });
  }

  void _simulateVitalsForPet(int petIndex) {
    // ...Sua lógica de simulação...
  }

  void stopSimulation() {
    _simulationTimer?.cancel();
  }

  VitalSign getLatestVitalForPet(String petId) {
    final random = Random();
    return VitalSign(
      timestamp: DateTime.now(),
      heartRate: 70 + random.nextDouble() * 20,
      temperature: 38.5 + random.nextDouble() * 1.0,
      spo2: 95 + random.nextDouble() * 4,
      activityLevel: 40 + random.nextDouble() * 50,
    );
  }

  Future<List<VitalSign>> getVitalHistory(String petId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final List<VitalSign> history = [];
    final random = Random();
    final now = DateTime.now();
    for (int i = 50; i > 0; i--) {
      history.add(
        VitalSign(
          timestamp: now.subtract(Duration(minutes: i * 5)),
          heartRate: 70 + random.nextDouble() * 20,
          temperature: 38.0 + random.nextDouble() * 1.5,
        ),
      );
    }
    return history;
  }

  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }
}

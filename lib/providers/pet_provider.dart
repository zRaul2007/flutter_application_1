import 'dart:async'; // Importa a biblioteca para usar o Timer.
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/pet_models.dart';

// A classe PetProvider estende ChangeNotifier.
// ChangeNotifier é uma classe simples do Flutter que permite que este objeto
// "notifique" outros objetos (nossos widgets) sobre mudanças.
// É a peça central do nosso gerenciamento de estado.
class PetProvider with ChangeNotifier {
  // --- DADOS ---

  // A lista de pets agora vive aqui, no nosso estado central.
  final List<Pet> _pets = [
    Pet(
      id: '1',
      name: 'Buddy',
      breed: 'Golden Retriever',
      species: Species.dog,
      age: 5,
      ownerId: 'user1',
      healthStatus: HealthStatus.stable,
      avatarUrl: 'https://i.imgur.com/v8R3xeg.jpeg',
      thresholds: VitalThresholds(
        heartRateMin: 60,
        heartRateMax: 140,
        temperatureMin: 37.5,
        temperatureMax: 39.2,
        spo2Min: 95,
      ),
    ),
    Pet(
      id: '2',
      name: 'Lucy',
      breed: 'Labrador',
      species: Species.dog,
      age: 3,
      ownerId: 'user1',
      healthStatus: HealthStatus.attention,
      avatarUrl: 'https://i.imgur.com/x51NnNT.jpeg',
      thresholds: VitalThresholds(
        heartRateMin: 60,
        heartRateMax: 150,
        temperatureMin: 37.5,
        temperatureMax: 39.2,
        spo2Min: 95,
      ),
    ),
  ];

  // A lista de alertas também vive aqui.
  final List<Alert> _alerts = [
    Alert(
      id: 'alert1',
      petId: '2',
      petName: 'Lucy',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      message: 'Frequência cardíaca acima do normal.',
      severity: 'high',
      acknowledged: false,
    ),
    Alert(
      id: 'alert2',
      petId: '1',
      petName: 'Buddy',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      message: 'Nível de SpO₂ levemente abaixo do esperado.',
      severity: 'medium',
      acknowledged: false,
    ),
  ];

  // NOVO: Referência para nosso Timer de simulação.
  Timer? _simulationTimer;

  // --- CONSTRUTOR ---

  // O construtor do Provider: Inicia a simulação assim que o app começa.
  PetProvider() {
    startSimulation();
  }

  // --- GETTERS ---

  // Getter público para que os widgets possam ler a lista de pets.
  List<Pet> get pets => [..._pets];

  // Getter público para os alertas, ordenados do mais novo para o mais antigo.
  List<Alert> get alerts {
    _alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return [..._alerts];
  }

  // --- MÉTODOS CRUD ---

  // CREATE
  void addPet({
    required String name,
    required String breed,
    required Species species,
    required int age,
    File? avatarFile, // NOVO
    required VitalThresholds thresholds, // Adicionado para receber os limites
  }) {
    final newPet = Pet(
      id: DateTime.now().toString(),
      name: name,
      breed: breed,
      species: species,
      age: age,
      avatarFile: avatarFile, // NOVO
      ownerId: 'user1',
      healthStatus: HealthStatus.unknown,
      // avatarUrl: 'https://i.imgur.com/GNq6f2s.png', // Removeremos o avatar padrão daqui
      thresholds: thresholds, // Usa os limites recebidos do formulário
    );
    _pets.add(newPet);
    notifyListeners();
  }

  // UPDATE
  void updatePet(Pet updatedPet) {
    final petIndex = _pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (petIndex >= 0) {
      _pets[petIndex] = updatedPet;
      notifyListeners();
    }
  }

  // DELETE
  void deletePet(String petId) {
    _pets.removeWhere((pet) => pet.id == petId);
    notifyListeners();
  }

  // MÉTODO PARA ALERTAS
  void acknowledgeAlert(String alertId) {
    final alertIndex = _alerts.indexWhere((alert) => alert.id == alertId);
    if (alertIndex != -1) {
      _alerts[alertIndex] = Alert(
        id: _alerts[alertIndex].id,
        petId: _alerts[alertIndex].petId,
        petName: _alerts[alertIndex].petName,
        timestamp: _alerts[alertIndex].timestamp,
        message: _alerts[alertIndex].message,
        severity: _alerts[alertIndex].severity,
        acknowledged: true, // A única mudança é aqui!
      );
      notifyListeners();
    }
  }

  // --- LÓGICA DA SIMULAÇÃO (NOVA SEÇÃO) ---

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
    final pet = _pets[petIndex];
    final random = Random();

    final newVital = VitalSign(
      timestamp: DateTime.now(),
      heartRate: pet.thresholds.heartRateMin + random.nextDouble() * 30,
      temperature: 38.0 + random.nextDouble() * 1.5,
      spo2: 94 + random.nextDouble() * 5,
    );

    HealthStatus newStatus = HealthStatus.stable;
    if (newVital.heartRate! > pet.thresholds.heartRateMax ||
        newVital.heartRate! < pet.thresholds.heartRateMin) {
      newStatus = HealthStatus.attention;
      _alerts.add(
        Alert(
          id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
          petId: pet.id,
          petName: pet.name,
          timestamp: DateTime.now(),
          message:
              'Frequência cardíaca incomum: ${newVital.heartRate!.toStringAsFixed(0)} BPM',
          severity: 'medium',
          acknowledged: false,
        ),
      );
    }
    if (newVital.spo2! < pet.thresholds.spo2Min) {
      newStatus = HealthStatus.critical;
      _alerts.add(
        Alert(
          id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
          petId: pet.id,
          petName: pet.name,
          timestamp: DateTime.now(),
          message: 'Nível de SpO₂ baixo: ${newVital.spo2!.toStringAsFixed(0)}%',
          severity: 'high',
          acknowledged: false,
        ),
      );
    }

    _pets[petIndex] = Pet(
      id: pet.id,
      name: pet.name,
      breed: pet.breed,
      species: pet.species,
      age: pet.age,
      ownerId: pet.ownerId,
      avatarUrl: pet.avatarUrl,
      avatarFile: pet.avatarFile, // NOVO
      thresholds: pet.thresholds,
      healthStatus: newStatus,
    );
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

  // --- LIMPEZA DE RECURSOS ---

  // Sobrescrevemos o método dispose para garantir que nosso timer seja cancelado
  // quando o provider não for mais necessário. É uma prática muito importante.
  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }
}

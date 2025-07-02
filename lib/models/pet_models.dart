import 'dart:io';
import 'package:flutter/material.dart';

// Ele define as classes (modelos) que representam os dados da nossa aplicação.
// Usar modelos de dados bem definidos torna o código mais seguro, legível e fácil de manter.

// Análogo ao seu enum 'Species' em types.ts
enum Species { dog, cat }

// Análogo ao seu enum 'HealthStatus' em types.ts
enum HealthStatus { stable, attention, critical, unknown }

// Análogo à sua interface 'User' em types.ts
class User {
  // 'final' significa que, uma vez que um objeto User é criado,
  // essas propriedades não podem ser alteradas. Isso promove a imutabilidade.
  final String id;
  final String email;
  final bool isGuest;

  // Este é o construtor da classe.
  // A palavra-chave 'required' garante que esses valores devem ser fornecidos
  // ao criar uma nova instância de User.
  User({required this.id, required this.email, required this.isGuest});
}

// Análogo à sua interface 'Pet' em types.ts
class Pet {
  final String id;
  final String name;
  final String breed;
  final Species species;
  final int age;
  final String?
  avatarUrl; // O '?' indica que este valor pode ser nulo (opcional).
  final File? avatarFile; // NOVO: Para a imagem local.
  final String ownerId;
  final HealthStatus healthStatus;
  final VitalThresholds thresholds;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.species,
    required this.age,
    this.avatarUrl,
    this.avatarFile, // NOVO
    required this.ownerId,
    required this.healthStatus,
    required this.thresholds,
  });

  // NOVO: Um getter para facilitar a obtenção da imagem.
  ImageProvider get avatar {
    if (avatarFile != null) {
      return FileImage(avatarFile!);
    }
    if (avatarUrl != null) {
      return NetworkImage(avatarUrl!);
    }
    // Lógica da imagem padrão baseada na espécie.
    if (species == Species.dog) {
      return const AssetImage('assets/images/default_dog.png');
    } else {
      return const AssetImage('assets/images/default_cat.png');
    }
  }
}

// Análogo à sua interface 'VitalSign' em types.ts
class VitalSign {
  final DateTime timestamp; // Usamos DateTime para melhor manipulação de datas.
  final double?
  heartRate; // Usamos double para números que podem ter casas decimais.
  final double? temperature;
  final double? spo2;
  final double? activityLevel;

  VitalSign({
    required this.timestamp,
    this.heartRate,
    this.temperature,
    this.spo2,
    this.activityLevel,
  });
}

// Análogo à sua interface 'VitalThresholds' em types.ts
class VitalThresholds {
  final double heartRateMin;
  final double heartRateMax;
  final double temperatureMin;
  final double temperatureMax;
  final double spo2Min;

  VitalThresholds({
    required this.heartRateMin,
    required this.heartRateMax,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.spo2Min,
  });
}

// Análogo à sua interface 'Alert' em types.ts
class Alert {
  final String id;
  final String petId;
  final String petName;
  final DateTime timestamp;
  final String message;
  final String
  severity; // Poderia ser um enum também: enum AlertSeverity { low, medium, high }
  final bool acknowledged;

  Alert({
    required this.id,
    required this.petId,
    required this.petName,
    required this.timestamp,
    required this.message,
    required this.severity,
    required this.acknowledged,
  });
}

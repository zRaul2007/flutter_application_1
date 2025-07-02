// lib/pages/add_edit_pet_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';
import '../widgets/pet_form.dart';

class AddEditPetPage extends StatelessWidget {
  final Pet? pet;
  const AddEditPetPage({Key? key, this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditing = pet != null;
    final title = isEditing ? 'Editar Pet' : 'Adicionar Pet';
    final petProvider = Provider.of<PetProvider>(context, listen: false);

    void handleSubmit(Pet petData) {
      if (isEditing) {
        petProvider.updatePet(petData);
      } else {
        // Para adicionar, passamos todos os dados coletados pelo formulário.
        petProvider.addPet(
          name: petData.name,
          breed: petData.breed,
          species: petData.species,
          age: petData.age,
          avatarFile: petData.avatarFile, // NOVO
          // --- CORREÇÃO AQUI ---
          // Agora passamos o objeto 'thresholds' que veio do formulário.
          thresholds: petData.thresholds,
        );
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PetForm(initialPet: pet, onSubmit: handleSubmit),
      ),
    );
  }
}

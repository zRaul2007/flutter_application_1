import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet_models.dart';

// Definimos um tipo para nossa função de callback para tornar o código mais limpo.
// Ela agora passará um objeto Pet completo.
typedef PetSubmitCallback = void Function(Pet petData);

class PetForm extends StatefulWidget {
  // O formulário agora pode receber um pet inicial (para modo de edição).
  final Pet? initialPet;
  final PetSubmitCallback onSubmit;

  const PetForm({Key? key, required this.onSubmit, this.initialPet})
    : super(key: key);

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final _formKey = GlobalKey<FormState>();

  // Um controlador para cada campo do formulário.
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _hrMinController;
  late TextEditingController _hrMaxController;
  late TextEditingController _tempMinController;
  late TextEditingController _tempMaxController;
  late TextEditingController _spo2MinController;

  Species _selectedSpecies = Species.dog;
  File? _pickedImage; // NOVO: Para armazenar a imagem selecionada.

  @override
  void initState() {
    super.initState();
    // Inicializamos os controladores.
    // Se estivermos em modo de edição (widget.initialPet != null),
    // preenchemos os campos com os dados do pet. Caso contrário, ficam vazios.
    final pet = widget.initialPet;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _breedController = TextEditingController(text: pet?.breed ?? '');
    _ageController = TextEditingController(text: pet?.age.toString() ?? '');
    _selectedSpecies = pet?.species ?? Species.dog;
    _pickedImage = pet?.avatarFile; // NOVO

    // Campos de limites (thresholds)
    _hrMinController = TextEditingController(
      text: pet?.thresholds.heartRateMin.toString() ?? '',
    );
    _hrMaxController = TextEditingController(
      text: pet?.thresholds.heartRateMax.toString() ?? '',
    );
    _tempMinController = TextEditingController(
      text: pet?.thresholds.temperatureMin.toString() ?? '',
    );
    _tempMaxController = TextEditingController(
      text: pet?.thresholds.temperatureMax.toString() ?? '',
    );
    _spo2MinController = TextEditingController(
      text: pet?.thresholds.spo2Min.toString() ?? '',
    );
  }

  @override
  void dispose() {
    // É importante limpar todos os controladores para liberar memória.
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _hrMinController.dispose();
    _hrMaxController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _spo2MinController.dispose();
    super.dispose();
  }

  // NOVO: Função para pegar a imagem.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    // Coleta todos os dados dos controladores e cria um novo objeto Pet.
    // Se for modo de edição, reutilizamos o ID e outras propriedades existentes.
    final petData = Pet(
      id: widget.initialPet?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      breed: _breedController.text,
      species: _selectedSpecies,
      age: int.parse(_ageController.text),
      avatarFile: _pickedImage, // NOVO
      thresholds: VitalThresholds(
        heartRateMin: double.parse(_hrMinController.text),
        heartRateMax: double.parse(_hrMaxController.text),
        temperatureMin: double.parse(_tempMinController.text),
        temperatureMax: double.parse(_tempMaxController.text),
        spo2Min: double.parse(_spo2MinController.text),
      ),
      // Propriedades que não são do formulário, mas precisam ser mantidas.
      ownerId: widget.initialPet?.ownerId ?? 'user1',
      healthStatus: widget.initialPet?.healthStatus ?? HealthStatus.unknown,
      avatarUrl: widget.initialPet?.avatarUrl,
    );

    // Chama o callback passando o objeto Pet completo.
    widget.onSubmit(petData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção de Foto do Pet (NOVO)
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (widget.initialPet?.avatar),
                  child:
                      _pickedImage == null && widget.initialPet?.avatar == null
                      ? const Icon(Icons.pets, size: 50)
                      : null,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Escolher Foto'),
                  onPressed: _pickImage,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Seção de Informações do Pet
          Text(
            'Informações do Pet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(labelText: 'Raça'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<Species>(
                  value: _selectedSpecies,
                  decoration: const InputDecoration(labelText: 'Espécie'),
                  items: Species.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSpecies = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Seção de Limites de Alerta
          Text(
            'Limites de Alerta',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _hrMinController,
                  decoration: const InputDecoration(labelText: 'BPM Mín.'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _hrMaxController,
                  decoration: const InputDecoration(labelText: 'BPM Máx.'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _tempMinController,
                  decoration: const InputDecoration(
                    labelText: 'Temp. Mín. (°C)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _tempMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Temp. Máx. (°C)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _spo2MinController,
            decoration: const InputDecoration(labelText: 'SpO₂ Mín. (%)'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _trySubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              widget.initialPet == null ? 'Adicionar Pet' : 'Salvar Alterações',
            ),
          ),
        ],
      ),
    );
  }
}
// Este widget é um formulário para adicionar ou editar informações de um pet.
// Ele permite que o usuário insira dados como nome, raça, idade, espécie,
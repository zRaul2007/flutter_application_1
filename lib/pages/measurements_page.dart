import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart'; // Importe o provider para consumir os dados.
import '../models/pet_models.dart';
import '../providers/pet_provider.dart'; // Importe o PetProvider.
import '../widgets/vital_sign_card.dart';
import '../widgets/vitals_chart.dart';

class MeasurementsPage extends StatefulWidget {
  final Pet pet;
  const MeasurementsPage({Key? key, required this.pet}) : super(key: key);

  @override
  _MeasurementsPageState createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  // O Future para o histórico continua aqui, ele só será carregado uma vez.
  late Future<List<VitalSign>> _vitalHistoryFuture;

  @override
  void initState() {
    super.initState();
    // Usamos o Provider.of para acessar o provider dentro do initState.
    // 'listen: false' é importante aqui porque não queremos que o initState
    // seja executado novamente.
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    _vitalHistoryFuture = petProvider.getVitalHistory(widget.pet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O tema do AppBar agora vem do nosso tema global em main.dart
      appBar: AppBar(title: Text(widget.pet.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Cabeçalho com a foto do pet (sem alterações)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.pet.avatarUrl ?? 'https://i.imgur.com/GNq6f2s.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.pet.breed} - ${widget.pet.species.displayName}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- ESTA É A PRINCIPAL MUDANÇA ---
            // Envolvemos a GridView com um Consumer para que os cards se atualizem em tempo real.
            Consumer<PetProvider>(
              builder: (context, petProvider, child) {
                // A cada notificação do provider, pegamos o sinal vital mais recente.
                final latestVital = petProvider.getLatestVitalForPet(
                  widget.pet.id,
                );

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Os valores dos cards agora vêm dos dados "ao vivo".
                    VitalSignCard(
                      icon: Icons.favorite,
                      label: 'Frequência Cardíaca',
                      value: latestVital.heartRate!.toStringAsFixed(2),
                      unit: 'BPM',
                      color: Colors.red,
                    ),
                    VitalSignCard(
                      icon: Icons.thermostat,
                      label: 'Temperatura',
                      value: latestVital.temperature!.toStringAsFixed(2),
                      unit: '°C',
                      color: Colors.orange,
                    ),
                    VitalSignCard(
                      icon: Icons.air,
                      label: 'SpO₂',
                      value: latestVital.spo2!.toStringAsFixed(2),
                      unit: '%',
                      color: Colors.blue,
                    ),
                    VitalSignCard(
                      icon: Icons.directions_run,
                      label: 'Atividade',
                      value: latestVital.activityLevel!.toStringAsFixed(2),
                      unit: '%',
                      color: Colors.green,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // O FutureBuilder para os gráficos permanece o mesmo,
            // exibindo o histórico carregado uma única vez.
            FutureBuilder<List<VitalSign>>(
              future: _vitalHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar o histórico: ${snapshot.error}',
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado histórico encontrado.'),
                  );
                }

                final history = snapshot.data!;
                final heartRateSpots = history
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.heartRate!))
                    .toList();
                final temperatureSpots = history
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.temperature!))
                    .toList();

                return Column(
                  children: [
                    VitalsChart(
                      title: 'Histórico de Frequência Cardíaca',
                      dataPoints: heartRateSpots,
                      lineColor: Colors.red,
                    ),
                    const SizedBox(height: 24),
                    VitalsChart(
                      title: 'Histórico de Temperatura',
                      dataPoints: temperatureSpots,
                      lineColor: Colors.orange,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

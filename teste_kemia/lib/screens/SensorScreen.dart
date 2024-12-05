import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  List<String> _sensors = [];
  final List<Map<String, String>> _sensorData = [];
  String? _selectedSensor;
  TextEditingController _sensorValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarSensores();
  }

  // Carrega os sensores da coleção 'sensor' no Firestore
  Future<void> _carregarSensores() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore.collection('sensor').get();

      setState(() {
        _sensors = snapshot.docs.map((doc) => doc['nome'].toString()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar sensores: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Salva os dados coletados no Firestore
  Future<void> _salvarDadosColetados() async {
    if (_sensorData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhum dado coletado para salvar!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Adiciona os dados de todos os sensores coletados
      await firestore.collection('sensor_data').add({
        'dataColeta': DateTime.now().toIso8601String(),
        'leituras': _sensorData.map((data) {
          return {
            'sensor': data['sensor'],
            'valor': data['value'],
            'data': Timestamp.now(),
          };
        }).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados salvos com sucesso no Firestore!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _sensorData.clear(); // Limpa a lista de dados coletados
        _sensorValueController.clear(); // Limpa o campo de texto
        _selectedSensor = null; // Reseta o dropdown
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Adiciona um dado coletado à lista
  void _adicionarDado() {
    if (_sensorValueController.text.isNotEmpty && _selectedSensor != null) {
      setState(() {
        _sensorData.add({
          'sensor': _selectedSensor!,
          'value': _sensorValueController.text,
        });
        _sensorValueController.clear(); // Limpa o campo de texto
        _selectedSensor = null; // Reseta o dropdown
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione um sensor e insira um valor.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Navega para a tela de cadastro de sensores
  void _navegarParaCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroSensorScreen()),
    );
    _carregarSensores(); // Atualiza a lista de sensores ao retornar
  }

  @override
  void dispose() {
    _sensorValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coleta de Sensores'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navegarParaCadastro, // Botão para cadastrar novo sensor
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Selecione um sensor'),
              value: _selectedSensor,
              items: _sensors.map((String sensor) {
                return DropdownMenuItem<String>(
                  value: sensor,
                  child: Text(sensor),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedSensor = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Digite os dados coletados',
                border: OutlineInputBorder(),
              ),
              controller: _sensorValueController,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _adicionarDado,
                  child: Text('Adicionar'),
                ),
                ElevatedButton(
                  onPressed: _salvarDadosColetados,
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _sensorData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${_sensorData[index]['sensor']}: ${_sensorData[index]['value']}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _sensorData.removeAt(index); // Remove o item da lista
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Cadastro de Sensores (CadastroSensorScreen)
class CadastroSensorScreen extends StatelessWidget {
  final TextEditingController _nomeSensorController = TextEditingController();

  Future<void> _salvarSensor(BuildContext context) async {
    if (_nomeSensorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira o nome do sensor.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('sensor').add({
        'nome': _nomeSensorController.text,
        'dataCadastro': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sensor cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Retorna para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar sensor: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Sensores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeSensorController,
              decoration: InputDecoration(
                labelText: 'Nome do Sensor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _salvarSensor(context),
              child: Text('Salvar Sensor'),
            ),
          ],
        ),
      ),
    );
  }
}

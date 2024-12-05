import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastroSensorScreen extends StatefulWidget {
  @override
  _CadastroSensorScreen createState() => _CadastroSensorScreen();
}

class _CadastroSensorScreen extends State<CadastroSensorScreen> {
  TextEditingController _sensorNameController = TextEditingController();

  Future<void> _salvarSensor() async {
    if (_sensorNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira o nome do sensor!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('sensor').add({
        'nome': _sensorNameController.text,
        'dataCadastro': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sensor cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      _sensorNameController.clear();
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
  void dispose() {
    _sensorNameController.dispose();
    super.dispose();
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
              controller: _sensorNameController,
              decoration: InputDecoration(
                labelText: 'Nome do Sensor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvarSensor,
              child: Text('Salvar Sensor'),
            ),
          ],
        ),
      ),
    );
  }
}

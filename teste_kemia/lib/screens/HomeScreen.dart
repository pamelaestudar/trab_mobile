import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste_kemia/screens/EstoqueScreen.dart';
import 'package:teste_kemia/screens/ProdutosScreen.dart';
import 'package:teste_kemia/screens/SensorScreen.dart';
import 'ChecklistScreen.dart';
import 'LoginScreen.dart'; // Importa Firestore


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            _buildHomeTile(
              context,
              title: 'Cadastro Checklist',
              icon: Icons.checklist,
              color: Colors.blue.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChecklistScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Coleta de Sensores',
              icon: Icons.sensors,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SensorScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Cadastro De Sensores',
              icon: Icons.cloud,
              color: Colors.orange.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroSensorScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Cadastro de Produto',
              icon: Icons.inventory,
              color: Colors.purple.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdutoCadastroScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Controle de Estoque',
              icon: Icons.store,
              color: Colors.purple.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstoqueScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

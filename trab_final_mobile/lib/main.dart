import 'package:flutter/material.dart';

import 'models/navigationModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      title: 'Gestão de Clientes e Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuNavigationModal(), // Define o Menu de Navegação como a tela inicial
    );
  }
}

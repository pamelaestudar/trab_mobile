import 'package:flutter/material.dart';
import '../models/pedido.dart';

class DetalhesPedidoScreen extends StatelessWidget {
  final Pedido pedido;

  DetalhesPedidoScreen({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${pedido.descricao}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Valor Total: R\$ ${pedido.valorTotal.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status: ${pedido.status}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Cliente: ${pedido.cliente.nome}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

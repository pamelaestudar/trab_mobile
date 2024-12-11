import 'package:flutter/material.dart';

import '../screens/cadastro_cliente.dart';
import '../screens/cadastro_pedido.dart';
import '../screens/listagem_clientes.dart';
import '../screens/listagem_pedido.dart';

class MenuNavigationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Gestão'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Implementar funcionalidade de logout, se necessário
              Navigator.pop(context);
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
              title: 'Listagem de Clientes',
              icon: Icons.people,
              color: Colors.blue.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListagemClientesScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Listagem de Pedidos',
              icon: Icons.shopping_cart,
              color: Colors.green.shade300,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListagemPedidosScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Cadastro de Cliente',
              icon: Icons.person_add,
              color: Colors.purple.shade200,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroClienteScreen()),
                );
              },
            ),
            _buildHomeTile(
              context,
              title: 'Cadastro de Pedido',
              icon: Icons.add_shopping_cart,
              color: Colors.orange.shade300,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroPedidoScreen()),
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
                  color: Colors.white,
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

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import 'cadastro_pedido.dart';
import 'detalhes_pedido.dart';

class ListagemPedidosScreen extends StatefulWidget {
  @override
  _ListagemPedidosScreenState createState() => _ListagemPedidosScreenState();
}

class _ListagemPedidosScreenState extends State<ListagemPedidosScreen> {
  List<Pedido> pedidos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarPedidos();
  }

  void carregarPedidos() async {
    try {
      List<Pedido> pedidosCarregados = await ApiService.buscarPedidos();
      setState(() {
        pedidos = pedidosCarregados;
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar pedidos: $error')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void excluirPedido(String id) async {
    try {
      bool sucesso = await ApiService.excluirPedido(id);
      if (sucesso) {
        carregarPedidos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido excluído com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir pedido.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pedidos'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
          ? Center(child: Text('Nenhum pedido cadastrado.'))
          : ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          Pedido pedido = pedidos[index];
          return Card(
            child: ListTile(
              title: Text(pedido.descricao),
              subtitle:
              Text("R\$ ${pedido.valorTotal.toStringAsFixed(2)}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CadastroPedidoScreen(pedido: pedido),
                        ),
                      ).then((_) => carregarPedidos());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => excluirPedido(pedido.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalhesPedidoScreen(pedido: pedido),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroPedidoScreen()),
          ).then((_) => carregarPedidos());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

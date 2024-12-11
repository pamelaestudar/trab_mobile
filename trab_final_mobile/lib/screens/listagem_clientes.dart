import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';
import 'cadastro_cliente.dart';

class ListagemClientesScreen extends StatefulWidget {
  @override
  _ListagemClientesScreenState createState() => _ListagemClientesScreenState();
}

class _ListagemClientesScreenState extends State<ListagemClientesScreen> {
  List<Cliente> clientes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  void carregarClientes() async {
    try {
      List<Cliente> clientesCarregados = await ApiService.buscarClientes();
      setState(() {
        clientes = clientesCarregados;
        isLoading = false;
      });
    } catch (error) {
      print("Erro ao buscar clientes: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes')),
      );
      setState(() {
        clientes = [];
        isLoading = false;
      });
    }
  }

  void excluirCliente(String id) async {
    try {
      bool sucesso = await ApiService.excluirCliente(id);
      if (sucesso) {
        carregarClientes();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente excluído com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir cliente.')),
        );
      }
    } catch (error) {
      print("Erro ao excluir cliente: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir cliente. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clientes.isEmpty
          ? Center(child: Text('Nenhum cliente cadastrado.'))
          : ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          Cliente cliente = clientes[index];
          return Card(
            child: ListTile(
              title: Text(cliente.nome),
              subtitle: Text('${cliente.cpf} - ${cliente.telefone}'),
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
                              CadastroClienteScreen(cliente: cliente),
                        ),
                      ).then((_) => carregarClientes());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => excluirCliente(cliente.id),
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
            MaterialPageRoute(builder: (context) => CadastroClienteScreen()),
          ).then((_) => carregarClientes());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

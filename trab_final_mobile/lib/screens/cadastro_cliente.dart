import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';

class CadastroClienteScreen extends StatefulWidget {
  final Cliente? cliente;

  CadastroClienteScreen({this.cliente});

  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nomeController.text = widget.cliente!.nome;
      _cpfController.text = widget.cliente!.cpf;
      _telefoneController.text = widget.cliente!.telefone;
      _enderecoController.text = widget.cliente!.endereco ?? "";
    }
  }

  void salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      Cliente cliente = Cliente(
        id: widget.cliente?.id ?? "",
        nome: _nomeController.text.trim(),
        cpf: _cpfController.text.trim(),
        telefone: _telefoneController.text.trim(),
        endereco: _enderecoController.text.trim(),
      );

      try {
        bool sucesso = await ApiService.salvarCliente(cliente);
        if (sucesso) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliente salvo com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar cliente.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o CPF.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o telefone.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: salvarCliente,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

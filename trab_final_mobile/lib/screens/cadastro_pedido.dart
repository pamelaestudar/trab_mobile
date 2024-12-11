import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import '../models/cliente.dart';

class CadastroPedidoScreen extends StatefulWidget {
  final Pedido? pedido;

  CadastroPedidoScreen({this.pedido});

  @override
  _CadastroPedidoScreenState createState() => _CadastroPedidoScreenState();
}

class _CadastroPedidoScreenState extends State<CadastroPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorTotalController = TextEditingController();
  String _status = "Em Processamento";
  String? _clienteSelecionado;
  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    carregarClientes();
    if (widget.pedido != null) {
      _descricaoController.text = widget.pedido!.descricao;
      _valorTotalController.text = widget.pedido!.valorTotal.toString();
      _status = widget.pedido!.status;
      _clienteSelecionado = widget.pedido!.cliente.id;
    }
  }

  void carregarClientes() async {
    try {
      List<Cliente> clientesCarregados = await ApiService.buscarClientes();
      setState(() {
        clientes = clientesCarregados;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $error')),
      );
    }
  }

  void salvarPedido() async {
    if (_formKey.currentState!.validate() && _clienteSelecionado != null) {
      Pedido pedido = Pedido(
        id: widget.pedido?.id ?? "",
        descricao: _descricaoController.text.trim(),
        valorTotal: double.parse(_valorTotalController.text.trim()),
        status: _status,
        cliente: clientes.firstWhere((c) => c.id == _clienteSelecionado),
      );

      try {
        bool sucesso = await ApiService.salvarPedido(pedido);
        if (sucesso) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pedido salvo com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar pedido.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione um cliente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pedido == null ? 'Novo Pedido' : 'Editar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorTotalController,
                decoration: InputDecoration(labelText: 'Valor Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Informe um valor válido.';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ["Em Processamento", "Enviado", "Entregue", "Cancelado"]
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<String>(
                value: _clienteSelecionado,
                items: clientes
                    .map((cliente) => DropdownMenuItem(
                  value: cliente.id,
                  child: Text(cliente.nome),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _clienteSelecionado = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Cliente'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: salvarPedido,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

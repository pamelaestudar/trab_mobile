import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProdutoCadastroScreen extends StatefulWidget {
  @override
  _ProdutoCadastroScreenState createState() => _ProdutoCadastroScreenState();
}

class _ProdutoCadastroScreenState extends State<ProdutoCadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeProdutoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();

  // Máscara para o campo de data
  final validadeMask = MaskTextInputFormatter(mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  final List<String> categorias = ['Ácidos', 'Básicos', 'Floculantes', 'Coagulantes', 'Desinfetantes', 'Corretivos de pH', 'Solventes'];
  final List<String> unidades = ['Unidade', 'Litro', 'Caixa', 'Pacote', 'Peça', 'Quilograma'];

  // Função para cadastrar o produto no Firebase com ID único
  Future<void> _cadastrarProduto() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Criando um novo documento com ID único
        DocumentReference docRef = await FirebaseFirestore.instance.collection('produtos').add({
          'nome': nomeProdutoController.text,
          'descricao': descricaoController.text,
          'quantidade': int.tryParse(quantidadeController.text) ?? 0,
          'validade': validadeController.text,
          'categoria': _selectedCategoria,
          'unidade': _selectedUnidade,
          'dataCadastro': FieldValue.serverTimestamp(),
        });

        // O Firestore gera automaticamente um ID único para cada documento
        String produtoId = docRef.id;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso! ID: $produtoId')),
        );

        // Limpar os campos após cadastro
        nomeProdutoController.clear();
        descricaoController.clear();
        quantidadeController.clear();
        validadeController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar o produto')),
        );
      }
    }
  }

  String? _selectedCategoria;
  String? _selectedUnidade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nomeProdutoController,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do Produto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: validadeController,
                decoration: InputDecoration(
                  labelText: 'Data de Validade',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [validadeMask], // Aplicando a máscara
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de validade';
                  }
                  if (value.length != 10) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoria = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Unidade de Medida',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: unidades.map((unidade) {
                  return DropdownMenuItem(
                    value: unidade,
                    child: Text(unidade),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnidade = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma unidade de medida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _cadastrarProduto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cadastrar Produto',
                    style: TextStyle(fontSize: 16),
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

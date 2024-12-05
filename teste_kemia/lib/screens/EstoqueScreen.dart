import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstoqueScreen extends StatefulWidget {
  @override
  _EstoqueScreenState createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _removerQuantidadeController = TextEditingController();

  // Função para remover quantidade e atualizar a tela
  Future<void> _removerEstoque(String produtoId, double quantidadeEmEstoque) async {
    if (produtoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID do produto não encontrado')),
      );
      return;
    }

    final quantidadeRemover = double.tryParse(_removerQuantidadeController.text) ?? 0;

    if (quantidadeRemover <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira uma quantidade válida para remover')),
      );
      return;
    }

    if (quantidadeRemover > quantidadeEmEstoque) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quantidade a remover não pode ser maior que o estoque')),
      );
      return;
    }

    try {
      DocumentSnapshot produtoDoc = await _firestore.collection('produtos').doc(produtoId).get();
      if (produtoDoc.exists) {
        var estoqueAtual = produtoDoc['quantidade'] ?? 0.0;

        if (estoqueAtual is! double) {
          throw Exception('Erro: Estoque não é um número válido');
        }

        await _firestore.collection('produtos').doc(produtoId).update({
          'quantidade': FieldValue.increment(-quantidadeRemover), // Decrementa a quantidade
        });

        // Após a remoção, recarrega os produtos para atualizar a tela
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantidade removida com sucesso!')),
        );
        _removerQuantidadeController.clear(); // Limpa o campo
      } else {
        throw Exception('Produto não encontrado no estoque');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover quantidade do estoque: ${e.toString()}')),
      );
    }
  }

  // Função para carregar todos os produtos
  Future<List<Map<String, dynamic>>> _obterEstoque() async {
    QuerySnapshot snapshot = await _firestore.collection('produtos').get();
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Adiciona o ID do documento ao mapa
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estoque'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _obterEstoque(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os produtos'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto encontrado.'));
          }

          List<Map<String, dynamic>> produtos = snapshot.data!;

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> produto = produtos[index];
              String produtoId = produto['id'] ?? '';
              String nome = produto['nome'] ?? 'Produto sem nome';
              String descricao = produto['descricao'] ?? 'Sem descrição';
              double quantidadeEmEstoque = produto['quantidade']?.toDouble() ?? 0.0;
              String unidadeMedida = produto['unidade'] ?? 'Unidade';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(nome),
                  subtitle: Text(descricao),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Quantidade: $quantidadeEmEstoque'),
                      SizedBox(height: 8),
                      Text('Unidade: $unidadeMedida'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Remover Quantidade'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _removerQuantidadeController,
                                decoration: InputDecoration(
                                  labelText: 'Quantidade a remover',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _removerEstoque(produtoId, quantidadeEmEstoque);
                                Navigator.pop(context);
                              },
                              child: Text('Remover'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

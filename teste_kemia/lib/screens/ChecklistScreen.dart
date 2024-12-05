import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<String> tarefas = [
    'Verificar nível de oxigênio',
    'Monitorar pressão da bomba',
    'Registrar temperatura da água',
    'Verificar filtros de efluentes',
  ];

  final List<String> comentarios = List<String>.filled(4, '');
  final List<bool> tarefasConcluidas = List<bool>.filled(4, false);

  Future<void> _salvarChecklist() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('checklists').add({
        'data': DateTime.now().toIso8601String(),
        'respostas': List.generate(tarefas.length, (index) {
          return {
            'tarefa': tarefas[index],
            'comentario': comentarios[index],
            'concluida': tarefasConcluidas[index],
            'data': Timestamp.now(),
          };
        }),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checklist salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        // Limpa os campos após salvar
        for (var i = 0; i < comentarios.length; i++) {
          comentarios[i] = '';
          tarefasConcluidas[i] = false;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar checklist: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarConfirmacaoSalvar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Você tem certeza que deseja salvar? Após salvar, as tarefas não poderão ser alteradas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Fecha o modal
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o modal
              _salvarChecklist(); // Salva os dados
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _verificarAntesDeSalvar() {
    bool todosConcluidos = tarefasConcluidas.every((concluida) => concluida);
    bool camposPreenchidos = comentarios.every((comentario) => comentario.isNotEmpty);

    // Validação: Tarefas não concluídas
    if (!todosConcluidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todas as tarefas devem ser concluídas antes de salvar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validação: Comentários vazios
    if (!camposPreenchidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos de comentário antes de salvar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Se todas as validações passaram, exibe o modal de confirmação
    _mostrarConfirmacaoSalvar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist Diário'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tarefas.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: tarefasConcluidas[index],
                          onChanged: (value) {
                            setState(() {
                              tarefasConcluidas[index] = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            tarefas[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: tarefasConcluidas[index]
                                  ? Colors.green
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Comentário',
                        hintText: 'Escreva algo...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          comentarios[index] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _verificarAntesDeSalvar, // Chama a função que faz a validação e exibe o modal
        label: Text('Salvar'),
        icon: Icon(Icons.save),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

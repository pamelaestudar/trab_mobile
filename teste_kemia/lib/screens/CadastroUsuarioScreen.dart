import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();

  String? _tipoSelecionado;

  void _cadastrar() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmaSenha = _confirmaSenhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmaSenha.isEmpty || _tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha todos os campos para continuar.")),
      );
      return;
    }

    if (!_validarEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("E-mail inválido!")),
      );
      return;
    }

    if (senha != confirmaSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("As senhas não correspondem!")),
      );
      return;
    }

    print('Cadastrado: $nome, $email, $_tipoSelecionado');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Usuário $nome cadastrado com sucesso!")),
    );
  }

  bool _validarEmail(String email) {
    return email.contains('@') && email.contains('.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              items: ['Operador', 'Analista'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _tipoSelecionado = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmaSenhaController,
              decoration: InputDecoration(
                labelText: 'Confirme a Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _cadastrar,
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}

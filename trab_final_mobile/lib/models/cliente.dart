class Cliente {
  String id;
  String nome;
  String cpf;
  String telefone;
  String? endereco;

  Cliente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    this.endereco,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    id: json['id'] ?? '',
    nome: json['nome'] ?? 'Nome não informado',
    cpf: json['cpf'] ?? 'CPF não informado',
    telefone: json['telefone'] ?? 'Telefone não informado',
    endereco: json['endereco'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'cpf': cpf,
    'telefone': telefone,
    'endereco': endereco,
  };
}

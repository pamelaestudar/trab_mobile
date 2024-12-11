import 'cliente.dart';

class Pedido {
  String id;
  String descricao;
  double valorTotal;
  String status;
  Cliente cliente;

  Pedido({
    required this.id,
    required this.descricao,
    required this.valorTotal,
    required this.status,
    required this.cliente,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
    id: json['id'],
    descricao: json['descricao'],
    valorTotal: json['valorTotal'],
    status: json['status'],
    cliente: Cliente.fromJson(json['cliente']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'descricao': descricao,
    'valorTotal': valorTotal,
    'status': status,
    'cliente': cliente.toJson(),
  };
}

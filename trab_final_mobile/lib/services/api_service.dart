import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/pedido.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  // Buscar Clientes
  static Future<List<Cliente>> buscarClientes() async {
    final url = Uri.parse('$baseUrl/clientes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar clientes: ${response.statusCode}');
    }
  }

  // Salvar Cliente (Criar ou Editar)
  static Future<bool> salvarCliente(Cliente cliente) async {
    final url = cliente.id.isNotEmpty
        ? Uri.parse('$baseUrl/clientes/${cliente.id}')
        : Uri.parse('$baseUrl/clientes');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Erro ao salvar cliente: ${response.statusCode}');
    }
  }

  // Excluir Cliente
  static Future<bool> excluirCliente(String id) async {
    final url = Uri.parse('$baseUrl/clientes/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao excluir cliente: ${response.statusCode}');
    }
  }

  // Buscar Pedidos
  static Future<List<Pedido>> buscarPedidos() async {
    final url = Uri.parse('$baseUrl/pedidos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pedidos: ${response.statusCode}');
    }
  }

  // Salvar Pedido (Criar ou Editar)
  static Future<bool> salvarPedido(Pedido pedido) async {
    final url = pedido.id.isNotEmpty
        ? Uri.parse('$baseUrl/pedidos/${pedido.id}')
        : Uri.parse('$baseUrl/pedidos');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Erro ao salvar pedido: ${response.statusCode}');
    }
  }

  // Excluir Pedido
  static Future<bool> excluirPedido(String id) async {
    final url = Uri.parse('$baseUrl/pedidos/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao excluir pedido: ${response.statusCode}');
    }
  }
}

import 'package:dio/dio.dart';
import '../models/tarjeta.dart';

class TarjetasService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://backend.espaciomayorcm.cl',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<List<Tarjeta>> obtenerTarjetas() async {
    final response = await _dio.get('/api/tarjetas');

    if (response.statusCode == 200) {
      final json = response.data;

      if (json is Map && json.containsKey('data')) {
        final lista = json['data'];

        if (lista is List) {
          return lista
              .map((item) => Tarjeta.fromJson(item))
              .toList();
        }
      }

      throw Exception('La respuesta no contiene una lista "data" válida.');
    }

    throw Exception('Error del servidor ${response.statusCode}');
  }
}

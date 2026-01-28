import 'package:dio/dio.dart';
import '../models/tarjeta.dart';
import '../exceptions/no_internet_exception.dart';

class TarjetasService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://backend.espaciomayorcm.cl',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<List<Tarjeta>> obtenerTarjetas() async {
    try {
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

        throw Exception('Formato de respuesta inválido');
      }

      throw Exception('Error del servidor ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        throw NoInternetException();
      }

      throw Exception('Error de conexión');
    }
  }
}

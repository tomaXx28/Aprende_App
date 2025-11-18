
import 'dart:convert';
class Tarjeta {
  final int id;
  final String? titulo;
  final String? subtitulo;
  final int? idPadre;
  final String tipoContenido;
  final String? disenoTarjeta;
  final String? urlPdf;
  final String? imagen;

  Tarjeta({
    required this.id,
    this.titulo,
    this.subtitulo,
    this.idPadre,
    required this.tipoContenido,
    this.disenoTarjeta,
    this.urlPdf,
    this.imagen,
  });

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    final contenido = json['contenido'];

    String? pdfUrl;
    if (contenido is Map && contenido['url'] != null) {
      pdfUrl = contenido['url'].toString();
    }
    return Tarjeta(
      id: int.tryParse(json['id'].toString()) ?? 0,
      titulo: fixWeirdAccents(json['titulo']?.toString() ?? ''),
      subtitulo: normalizeBrokenUtf(json['subtitulo']?.toString() ?? ''),
      tipoContenido: json['tipo_contenido']?.toString() ?? '',
      disenoTarjeta: json['diseno_tarjeta']?.toString(),
      idPadre: json['id_padre'] != null
          ? int.tryParse(json['id_padre'].toString())
          : null,
      urlPdf: pdfUrl,

      imagen: () {
        // Aceptar todas las variantes que usa el backend
        final posiblesKeys = [
          'imagenURL',
          'imagenUrl',
          'imagen_url',
          'imageUrl',
          'imageURL',
        ];

        for (final key in posiblesKeys) {
          if (json[key] != null &&
              json[key].toString().trim().isNotEmpty) {
            return json[key].toString().trim();
          }
        }
        return null;
      }(),
    );
  }

}
String fixWeirdAccents(String text) {
  return text
      .replaceAll('%cc%81', 'í')
      .replaceAll('%CC%81', 'í')
      .replaceAll('%c3%ad', 'í')
      .replaceAll('%C3%AD', 'í')

      // otros patrones que podrían aparecer
      .replaceAll('%cc%81', '́') // acento suelto
      .replaceAll('í', 'í')
      .replaceAll('Í', 'Í');
}


String normalizeBrokenUtf(String text) {
  if (text.isEmpty) return text;

  try {
    // 1) Reemplaza los %xx por su byte real
    final bytes = <int>[];
    for (var i = 0; i < text.length; i++) {
      if (text[i] == '%' && i + 2 < text.length) {
        final hex = text.substring(i + 1, i + 3);
        final val = int.tryParse(hex, radix: 16);
        if (val != null) {
          bytes.add(val);
          i += 2; // saltar los dos dígitos
          continue;
        }
      }
      bytes.add(text.codeUnitAt(i));
    }

    // 2) Decodifica como UTF-8
    final decoded = utf8.decode(bytes, allowMalformed: true);

    // 3) Normaliza a NFC (caracteres compuestos)
    return decoded;
  } catch (_) {
    return text;
  }
}

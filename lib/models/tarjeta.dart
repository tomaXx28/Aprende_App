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

  /// ⭐ CLAVE: contenido completo (aquí viene id_lista)
  final Map<String, dynamic>? contenido;

  Tarjeta({
    required this.id,
    this.titulo,
    this.subtitulo,
    this.idPadre,
    required this.tipoContenido,
    this.disenoTarjeta,
    this.urlPdf,
    this.imagen,
    this.contenido,
  });

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    // contenido puede traer id_lista, url, etc.
    final dynamic contenidoRaw = json['contenido'];

    final Map<String, dynamic>? contenido =
        contenidoRaw is Map<String, dynamic>
            ? Map<String, dynamic>.from(contenidoRaw)
            : null;

    // URL del PDF (cuando corresponde)
    String? pdfUrl;
    if (contenido != null &&
        contenido.containsKey('url') &&
        contenido['url'] != null) {
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

      /// ⭐ guardamos TODO el contenido
      contenido: contenido,
    );
  }
}

/// ---------------------------------------------------------------------------
/// FIXES DE TEXTO / ENCODING
/// ---------------------------------------------------------------------------

String fixWeirdAccents(String text) {
  return text
      .replaceAll('Ã¡', 'á')
      .replaceAll('Ã©', 'é')
      .replaceAll('Ã­', 'í')
      .replaceAll('Ã³', 'ó')
      .replaceAll('Ãº', 'ú')
      .replaceAll('Ã±', 'ñ')
      .replaceAll('Ã', 'Á')
      .replaceAll('Ã‰', 'É')
      .replaceAll('Ã', 'Í')
      .replaceAll('Ã“', 'Ó')
      .replaceAll('Ãš', 'Ú')
      .replaceAll('Ã‘', 'Ñ')
      .replaceAll('â', '’')
      .replaceAll('â', '–')
      .replaceAll('â', '“')
      .replaceAll('â', '”')
      .replaceAll('Â¿', '¿')
      .replaceAll('Â¡', '¡')
      .replaceAll('Âº', 'º')
      .replaceAll('Â°', '°')
      .replaceAll('â€¢', '•')
      .replaceAll('â¢', '•');
}

String normalizeBrokenUtf(String text) {
  try {
    return utf8.decode(latin1.encode(text));
  } catch (_) {
    return text;
  }
}

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
      titulo: json['titulo']?.toString(),
      subtitulo: json['subtitulo']?.toString(),
      tipoContenido: json['tipo_contenido']?.toString() ?? '',
      disenoTarjeta: json['diseno_tarjeta']?.toString(),
      idPadre: json['id_padre'] != null
          ? int.tryParse(json['id_padre'].toString())
          : null,
      urlPdf: pdfUrl,
      imagen: json['imagenURL']?.toString(),
    );
  }
}

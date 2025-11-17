import 'package:aprende_app/utils/extraer_categorias.dart';
import '../models/tarjeta.dart';
import '../models/categoria_pdf.dart';


List<CategoriaPdf> agruparPorCategoria(List<Tarjeta> tarjetas) {
  final pdfs = tarjetas.where(
    (t) => t.tipoContenido == "pdf" && t.urlPdf != null && t.urlPdf!.isNotEmpty,
  );

  final Map<String, List<Tarjeta>> mapa = {};

  for (final pdf in pdfs) {
    final categoria = extraerCategoriaDesdeUrl(pdf.urlPdf!);

    mapa.putIfAbsent(categoria, () => []);
    mapa[categoria]!.add(pdf);
  }

  final List<CategoriaPdf> resultado = [];

  // Convertir mapa en lista de categorías
  mapa.forEach((categoria, listaPdfs) {
    resultado.add(
      CategoriaPdf(
        categoria: Tarjeta(
          id: categoria.hashCode,
          titulo: categoria,
          subtitulo: "Guías disponibles",
          tipoContenido: "categoria",
          disenoTarjeta: "",
          urlPdf: null,
        ),
        pdfs: listaPdfs,
      ),
    );
  });

  // Ordenar alfabéticamente
  resultado.sort((a, b) => a.categoria.titulo!.compareTo(b.categoria.titulo!));

  return resultado;
}

String extraerCategoriaDesdeUrl(String url) {
  final marker = "/assets/pdf/";
  final index = url.indexOf(marker);

  if (index == -1) return "Otros";

  final path = url.substring(index + marker.length);

  // ejemplo: aprende-a-usar-tu-celular/app-mayor/archivo.pdf
  final segmentos = path.split("/");

  if (segmentos.isEmpty) return "Otros";

  String categoria = segmentos.first.trim();

  if (categoria.isEmpty) return "Otros";

  // Reemplazar caracteres problemáticos
  categoria = categoria
      .replaceAll("%20", " ")
      .replaceAll("-", " ")
      .replaceAll("_", " ");

  // Eliminar números iniciales (por si vienen carpetas tipo "01-finanzas")
  categoria = categoria.replaceAll(RegExp(r'^\d+'), '').trim();

  // Capitalizar cada palabra
  categoria = categoria
      .split(" ")
      .map((w) =>
          w.isEmpty ? "" : w[0].toUpperCase() + (w.length > 1 ? w.substring(1).toLowerCase() : ""))
      .join(" ");

  // Correcciones automáticas para nombres famosos
  final correcciones = {
    "Caja Los Heroes": "Caja Los Héroes",
    "Que": "Qué",
    "App Mayor": "App Mayor",
    "Finanzas Y Emprendimientos": "Finanzas y emprendimientos",
  };

  correcciones.forEach((k, v) {
    if (categoria == k) categoria = v;
  });

  return categoria;
}

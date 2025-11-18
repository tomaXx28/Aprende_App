import 'package:characters/characters.dart';

/// Normaliza caracteres Unicode (por ejemplo: "í" → "í")
String normalizeUnicode(String input) {
  try {
    // Characters reinterpreta secuencias como "i◌́" → "í"
    return input.characters.toString();
  } catch (_) {
    return input;
  }
}

/// Extrae la categoría desde la URL del PDF.
/// Mantiene las validaciones y lógica original, pero ahora:
///  - Decodifica UTF-8
///  - Elimina secuencias problemáticas como %cc%81
///  - Normaliza tildes
///  - Corrige nombres automáticamente
String extraerCategoriaDesdeUrl(String url) {
  // --- 1) DECODIFICAR URL COMPLETA
  // Maneja '%20', '%C3%AD', '%cc%81', etc.
  try {
    url = Uri.decodeFull(url);
  } catch (_) {
    // Si algo falla, seguimos con la URL original
  }

  // --- 2) NORMALIZAR UNICODE (evita que aparezca Líderes como Li%cc%81deres)
  url = normalizeUnicode(url);

  // --- 3) Localizar la carpeta donde está el PDF
  // Ejemplo: .../assets/pdf/aprende-a-usar-tu-celular/app-mayor/archivo.pdf
  const marker = "/assets/pdf/";
  final index = url.indexOf(marker);

  /* if (index == -1) return "Otros";
 */
  final path = url.substring(index + marker.length);

  // --- 4) Extraer primer segmento como categoría
  final segmentos = path.split("/");

  /* if (segmentos.isEmpty) return "Otros"; */

  String categoria = segmentos.first.trim();

/*   if (categoria.isEmpty) return "Otros"; */

  // --- 5) LIMPIEZA DE CARACTERES
  categoria = categoria
      .replaceAll("%20", " ")
      .replaceAll("_", " ")
      .replaceAll("-", " ")
      .replaceAll("%cc%81", "")      // elimina basura residual
      .replaceAll("%C3%AD", "í")
      .replaceAll("%C3%A9", "é")
      .replaceAll("%C3%B3", "ó")
      .replaceAll("%C3%A1", "á")
      .replaceAll("%C3%BA", "ú")
      .replaceAll("%C3%B1", "ñ");

  // Re-normalizar por si quedan combinaciones
  categoria = normalizeUnicode(categoria);

  // --- 6) Eliminar números iniciales (ej: "01-finanzas")
  categoria = categoria.replaceAll(RegExp(r'^\d+'), '').trim();

  // --- 7) Capitalización inteligente
  categoria = categoria
      .split(" ")
      .map((w) =>
          w.isEmpty ? "" : w[0].toUpperCase() + (w.length > 1 ? w.substring(1).toLowerCase() : ""))
      .join(" ");

  // --- 8) Correcciones manuales (respetando tu lógica original)
  final correcciones = {
    "Caja Los Heroes": "Caja Los Héroes",
    "Que": "Qué",
    "App Mayor": "App Mayor",
    "Finanzas Y Emprendimientos": "Finanzas y emprendimientos",

    // nuevas correcciones comunes
    "Aprende A Usar Tu Celular": "Aprende a usar tu celular",
    "Cursos Y Capacitaciones": "Cursos y capacitaciones",
    "Salud Y Bienestar": "Salud y bienestar",
    "100 Lideres Mayores 2025": "100 Líderes Mayores 2025",
  };

  if (correcciones.containsKey(categoria)) {
    categoria = correcciones[categoria]!;
  }

  return categoria;
}

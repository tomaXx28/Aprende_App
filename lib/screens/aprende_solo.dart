import 'package:flutter/material.dart';
import '../models/tarjeta.dart';
import '../utils/extraer_categorias.dart';
import 'visor_pdf_screen.dart';

class HomeAprendeScreen extends StatelessWidget {
  final List<Tarjeta> todasLasTarjetas;

  const HomeAprendeScreen({
    super.key,
    required this.todasLasTarjetas,
  });

  @override
  Widget build(BuildContext context) {
    const categoriaBuscada = "Aprende a usar tu celular";

    // Filtrar solo PDFs
    final pdfs = todasLasTarjetas.where((t) => t.tipoContenido == "pdf").toList();

    // Filtrar por categoría
    final filtrados = pdfs.where((t) {
      final cat = extraerCategoriaDesdeUrl(t.urlPdf ?? "");
      return cat == categoriaBuscada;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aprende a usar tu celular"),
        elevation: 0,
        backgroundColor: const Color(0xFF1F2C6E),
      ),
      backgroundColor: const Color(0xFFF9F4FD),
      body: filtrados.isEmpty
          ? const Center(
              child: Text(
                "No hay contenido disponible.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: filtrados.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pdf = filtrados[index];
                return _PdfCard(pdf: pdf);
              },
            ),
    );
  }
}

class _PdfCard extends StatelessWidget {
  final Tarjeta pdf;

  const _PdfCard({required this.pdf});

  @override
  Widget build(BuildContext context) {
    final titulo = pdf.titulo ?? "";
    final subtitulo = pdf.subtitulo ?? "";

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VisorPdfScreen(
              titulo: titulo,
              url: pdf.urlPdf!,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLeading(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitulo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  /// Muestra imagen si existe, si no icono PDF rojo
  Widget _buildLeading() {
    // Si tiene imagen
    if (pdf.imagen != null &&
        pdf.imagen!.trim().isNotEmpty &&
        pdf.imagen!.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          pdf.imagen!,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _iconoPdf(),
        ),
      );
    }

    // Si no tiene imagen → ícono PDF
    return _iconoPdf();
  }

  Widget _iconoPdf() {
    return const Icon(
      Icons.picture_as_pdf_rounded,
      size: 46,
      color: Colors.red,
    );
  }
}

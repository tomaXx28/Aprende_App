import 'package:aprende_app/services/agrupador_pdf.dart';
import 'package:aprende_app/services/tarjeta_services.dart';
import 'package:flutter/material.dart';

import '../models/categoria_pdf.dart';
import '../models/tarjeta.dart';
import 'visor_pdf_screen.dart';

class CategoriasPdfsScreen extends StatefulWidget {
  const CategoriasPdfsScreen({super.key});

  @override
  State<CategoriasPdfsScreen> createState() => _CategoriasPdfsScreenState();
}

class _CategoriasPdfsScreenState extends State<CategoriasPdfsScreen> {
  final _service = TarjetasService();
  late Future<List<Tarjeta>> _futurePdfs;

  @override
  void initState() {
    super.initState();
    _futurePdfs = _cargarSoloAprende();
  }

  /// 🔥 Carga solo los PDFs de la categoría "Aprende a usar tu celular"
  Future<List<Tarjeta>> _cargarSoloAprende() async {
    final tarjetas = await _service.obtenerTarjetas();
    final categorias = agruparPorCategoria(tarjetas);

    // Buscar categoría exacta
    final cat = categorias.firstWhere(
      (c) =>
          (c.categoria.titulo ?? "").toLowerCase() ==
          "aprende a usar tu celular".toLowerCase(),
      orElse: () => CategoriaPdf(
        categoria: Tarjeta(id: 0, titulo: "", subtitulo: "", tipoContenido: ''),
        pdfs: [],
      ),
    );

    return cat.pdfs; // <-- PDFs ya filtrados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: const SizedBox.shrink(),
        title: const Text('Bienvenido a Aprende'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Tarjeta>>(
          future: _futurePdfs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar PDFs:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final pdfs = snapshot.data ?? [];

            if (pdfs.isEmpty) {
              return const Center(
                child: Text('No hay guías disponibles por ahora.'),
              );
            }

            /// 🔥 MOSTRAR PDFS DIRECTAMENTE EN EL HOME
            return ListView.separated(
              itemCount: pdfs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final pdf = pdfs[i];
                return _PdfCard(
                  pdf: pdf,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VisorPdfScreen(
                          url: pdf.urlPdf ?? "",
                          titulo: pdf.titulo ?? "Guía",
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔥  MISMA TARJETA PDF QUE USAS EN LISTA_PDF_SCREEN
/// ---------------------------------------------------------------------------

class _PdfCard extends StatelessWidget {
  final Tarjeta pdf;
  final VoidCallback onTap;

  const _PdfCard({required this.pdf, required this.onTap});

  Widget _buildPdfLeading(Tarjeta pdf) {
    if (pdf.imagen != null && pdf.imagen!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          pdf.imagen!,
          width: 42,
          height: 42,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.picture_as_pdf, size: 42, color: Colors.red),
        ),
      );
    }

    return const Icon(Icons.picture_as_pdf, size: 42, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    final title = pdf.titulo ?? 'Sin título';
    final subtitle = pdf.subtitulo ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildPdfLeading(pdf),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

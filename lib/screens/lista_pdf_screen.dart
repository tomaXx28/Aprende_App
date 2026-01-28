import 'package:flutter/material.dart';

import '../models/tarjeta.dart';
import 'visor_pdf_screen.dart';

class ListaPdfsScreen extends StatelessWidget {
  final Tarjeta categoria;
  final List<Tarjeta> pdfs;

  const ListaPdfsScreen({
    super.key,
    required this.categoria,
    required this.pdfs,
  });

  @override
  Widget build(BuildContext context) {
    final title = categoria.titulo ?? 'Guías';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 80,
        leading: const _BackButton(),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pdfs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final pdf = pdfs[i];
          return _PdfCard(
            pdf: pdf,
            onTap: () {
              if (pdf.urlPdf == null || pdf.urlPdf!.isEmpty) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisorPdfScreen(
                    url: pdf.urlPdf!,
                    titulo: pdf.titulo ?? 'Guía',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
        ),
      );
    }

    return const Icon(Icons.picture_as_pdf, size: 48, color: Colors.red);
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
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ TÍTULO GRANDE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    // ⭐ SUBTÍTULO LEGIBLE
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Inter',
                        color: Color(0xFF4A4A4A),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 36,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF242E74)),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Volver',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF242E74),
      selectedItemColor: const Color(0xFFE68C3A),
      unselectedItemColor: Colors.white,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notificaciones',
        ),
      ],
      onTap: (_) {},
    );
  }
}

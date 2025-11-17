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
        leadingWidth: 80,
        leading: _BackButton(),
        title: Text(title),
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

  const _PdfCard({
    required this.pdf,
    required this.onTap,
  });

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
            const Icon(Icons.picture_as_pdf, size: 42, color: Colors.red),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
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

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
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
              iconSize: 40,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF242E74)),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Volver',
            style: TextStyle(color: Colors.white, fontSize: 15),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
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

import 'package:aprende_app/screens/lista_pdf_screen.dart';
import 'package:aprende_app/services/agrupador_pdf.dart';
import 'package:aprende_app/services/tarjeta_services.dart';
import 'package:flutter/material.dart';

import '../models/categoria_pdf.dart';
import '../models/tarjeta.dart';


class CategoriasPdfsScreen extends StatefulWidget {
  const CategoriasPdfsScreen({super.key});

  @override
  State<CategoriasPdfsScreen> createState() => _CategoriasPdfsScreenState();
}

class _CategoriasPdfsScreenState extends State<CategoriasPdfsScreen> {
  final _service = TarjetasService();
  late Future<List<CategoriaPdf>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _futureCategorias = _cargar();
  }

  Future<List<CategoriaPdf>> _cargar() async {
    final tarjetas = await _service.obtenerTarjetas();
    final categorias = agruparPorCategoria(tarjetas);

    // Ordenamos por título para que quede más bonito
    categorias.sort((a, b) =>
        (a.categoria.titulo ?? '').compareTo(b.categoria.titulo ?? ''));

    return categorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: const SizedBox.shrink(), // sin botón volver en home
        title: const Text('Aprende sobre tecnología'),
      ),
      bottomNavigationBar: const _BottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<CategoriaPdf>>(
          future: _futureCategorias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar categorías:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final categorias = snapshot.data ?? [];

            if (categorias.isEmpty) {
              return const Center(
                child: Text('No hay guías disponibles por ahora.'),
              );
            }

            return ListView.separated(
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final cat = categorias[i];
                return _CategoriaCard(
                  categoria: cat.categoria,
                  cantidad: cat.pdfs.length,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaPdfsScreen(
                          categoria: cat.categoria,
                          pdfs: cat.pdfs,
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

class _CategoriaCard extends StatelessWidget {
  final Tarjeta categoria;
  final int cantidad;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.categoria,
    required this.cantidad,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = categoria.titulo ?? 'Sin título';
    final subtitle = categoria.subtitulo ?? 'Guías disponibles';

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
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
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F8FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: const Icon(Icons.menu_book, size: 50),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$cantidad guía(s)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
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
      currentIndex: 0,
      onTap: (_) {},
    );
  }
}

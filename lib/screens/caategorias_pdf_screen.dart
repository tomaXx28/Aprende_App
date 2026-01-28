import 'package:aprende_app/exceptions/no_internet_exception.dart';
import 'package:flutter/material.dart';
import 'package:aprende_app/services/tarjeta_services.dart';
import '../models/tarjeta.dart';
import 'lista_pdf_screen.dart';

class CategoriasPdfsScreen extends StatefulWidget {
  const CategoriasPdfsScreen({super.key});

  @override
  State<CategoriasPdfsScreen> createState() => _CategoriasPdfsScreenState();
}

class _CategoriasPdfsScreenState extends State<CategoriasPdfsScreen> {
  final _service = TarjetasService();
  late Future<List<Tarjeta>> _futureCategorias;
  List<Tarjeta> _todas = [];

  @override
  void initState() {
    super.initState();
    _futureCategorias = _cargarCategorias();
  }

  /// ⭐ Carga carpetas de "Aprende sobre tecnología" (id = 3)
  Future<List<Tarjeta>> _cargarCategorias() async {
    final tarjetas = await _service.obtenerTarjetas();
    _todas = tarjetas;

    // raíz real
    final raiz = tarjetas.firstWhere((t) => t.id == 3);

    // carpetas hijas
    final carpetas = tarjetas.where((t) {
      final titulo = (t.titulo ?? "").toLowerCase().trim();
      return t.idPadre == raiz.id &&
          t.tipoContenido.toLowerCase() != "pdf" &&
          titulo != "pinterest" &&
          titulo != "habilidades digitales" &&
          titulo != "aprende a usar aplicaciones";
    }).toList();

    return carpetas;
  }

  int? _obtenerIdLista(Tarjeta categoria) {
    try {
      final contenido = categoria.contenido;
      if (contenido == null) return null;
      return int.tryParse(contenido["id_lista"].toString());
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color(0xFF242E74), 
  elevation: 0,
  centerTitle: true,
  toolbarHeight: 72,
  title: const Text(
    'Aprende sobre tecnología',
    style: TextStyle(
      fontSize: 24,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Tarjeta>>(
          future: _futureCategorias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
  if (snapshot.error is NoInternetException) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No hay conexión a internet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Conéctate para ver las guías disponibles.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _futureCategorias = _cargarCategorias();
              });
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  return const Center(
    child: Text('Ocurrió un error al cargar la información'),
  );
}


            final categorias = snapshot.data ?? [];

            if (categorias.isEmpty) {
              return const Center(child: Text('No hay contenido disponible.'));
            }

            return ListView.separated(
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (_, i) {
                final categoria = categorias[i];

                return _CategoriaCard(
                  categoria: categoria,
                  onTap: () {
                    final idLista = _obtenerIdLista(categoria);

                    final pdfs = _todas.where((t) {
                      return idLista != null &&
                          t.idPadre == idLista &&
                          t.tipoContenido.toLowerCase() == "pdf";
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaPdfsScreen(
                          categoria: categoria,
                          pdfs: pdfs,
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
/// TARJETA DE CATEGORÍA (UI NUEVA)
/// ---------------------------------------------------------------------------

class _CategoriaCard extends StatelessWidget {
  final Tarjeta categoria;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.categoria,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (categoria.imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  categoria.imagen!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(Icons.folder, size: 56),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoria.titulo ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if ((categoria.subtitulo ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        categoria.subtitulo!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Inter',
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}

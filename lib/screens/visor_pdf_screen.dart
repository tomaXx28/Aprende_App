import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VisorPdfScreen extends StatefulWidget {
  final String titulo;
  final String url;

  const VisorPdfScreen({
    super.key,
    required this.titulo,
    required this.url,
  });

  @override
  State<VisorPdfScreen> createState() => _VisorPdfScreenState();
}

class _VisorPdfScreenState extends State<VisorPdfScreen>
    with SingleTickerProviderStateMixin {
  String? pdfPath;
  int totalPages = 0;
  int currentPage = 0;
  late AnimationController pageFlipController;

  PDFViewController? pdfController;

  bool isForward = true;

  @override
  void initState() {
    super.initState();

    pageFlipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _descargarPDF();
  }

  Future<void> _descargarPDF() async {
    final response = await http.get(Uri.parse(widget.url));
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/temp.pdf");
    await file.writeAsBytes(response.bodyBytes);
    setState(() => pdfPath = file.path);
  }

  void _goTo(int page, bool forward) async {
    if (page < 0 || page >= totalPages) return;

    setState(() => isForward = forward);

    await pageFlipController.forward(from: 0);

    pdfController?.setPage(page);

    setState(() => currentPage = page);
  }

  void _next() => _goTo(currentPage + 1, true);
  void _previous() => _goTo(currentPage - 1, false);

  @override
  void dispose() {
    pageFlipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotation = Tween<double>(
      begin: 0,
      end: isForward ? -1.6 : 1.6, // flip hacia un lado u otro
    ).animate(CurvedAnimation(
      parent: pageFlipController,
      curve: Curves.easeOut,
    ));

    final translation = Tween<double>(
      begin: 0,
      end: isForward ? -180 : 180,
    ).animate(CurvedAnimation(
      parent: pageFlipController,
      curve: Curves.easeOut,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF242E74),
        leadingWidth: 80,
        leading: _BotonVolver(),
        title: Text(widget.titulo),
      ),

      body: pdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                AnimatedBuilder(
                  animation: pageFlipController,
                  builder: (context, child) =>
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3,2,0.001)
                          ..rotateY(rotation.value)
                          ..translate(translation.value)
                          ..scale(1.0 - (pageFlipController.value * 0.02)),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 10,
                                spreadRadius: -3,
                                offset: Offset(isForward ? -10 : 10, 0),
                              )
                            ],
                          ),
                          child: PDFView(
                            key: ValueKey(currentPage),
                            filePath: pdfPath!,
                            enableSwipe: false,
                            swipeHorizontal: false,
                            defaultPage: currentPage,
                            fitEachPage: true,
                            fitPolicy: FitPolicy.BOTH,
                            onRender: (pages) {
                              setState(() => totalPages = pages ?? 0);
                            },
                            onViewCreated: (controller) =>
                                pdfController = controller,
                          ),
                        ),
                      ),
                ),

                // ---------- BARRA INFERIOR ----------
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BarraInferior(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    next: _next,
                    prev: _previous,
                  ),
                ),
              ],
            ),
    );
  }
}

// ---------------- BOTÓN VOLVER ----------------
class _BotonVolver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 32,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF242E74)),
            ),
          ),
          const SizedBox(height: 2),
          const Text("Volver",
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// -------------- BARRA INFERIOR --------------
class _BarraInferior extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback next;
  final VoidCallback prev;

  const _BarraInferior({
    required this.currentPage,
    required this.totalPages,
    required this.next,
    required this.prev,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              currentPage > 0
                  ? _BotonNavegacion(icon: Icons.chevron_left, onTap: prev)
                  : const SizedBox(width: 60),

              currentPage < totalPages - 1
                  ? _BotonNavegacion(icon: Icons.chevron_right, onTap: next)
                  : const SizedBox(width: 60),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            "Página ${currentPage + 1} de $totalPages",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonNavegacion extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BotonNavegacion({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 38, color: Color(0xFF242E74)),
      ),
    );
  }
}

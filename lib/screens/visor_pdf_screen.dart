import 'dart:io';

import 'package:aprende_app/EM/buttoms.dart';
import 'package:aprende_app/EM/constants.dart';
import 'package:aprende_app/EM/screen_basse_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
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
  String? pdfPath = '';
  int totalPages = 0;
  int currentPage = 0;
  int? prevPage = 0;

  PDFViewController? pdfController;
  late Animation<double> animation;
  bool animateForward = true;

  // Para el botón de perfil en el AppBar
/*   final GlobalKey<ProfileActionButtonState> _profileKey =
      GlobalKey<ProfileActionButtonState>();
 */
  @override
  void initState() {
    super.initState();
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() {
        prevPage = currentPage;
        currentPage++;
        animateForward = true;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        prevPage = currentPage;
        currentPage--;
        animateForward = false;
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF242E74),
      toolbarHeight: 100,
      title: Text(
        widget.titulo,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      /* leading: CustomerLeading(),
      leadingWidth: 80,
      actions: kIsWeb
          ? []
          : [
              ProfileActionButton(
                key: _profileKey,
                nullBoton: false,
              ),
            ], */
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 150 * MediaQuery.sizeOf(context).height / 770,
          color: Colors.black,
          child: Column(
            children: [
              Container(height: 10 * MediaQuery.sizeOf(context).height / 770),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Visibility(
                    visible: currentPage > 0,
                    replacement: Flexible(
                      child: SizedBox(
                        height: 1,
                        width: MediaQuery.of(context).size.height / 12,
                      ),
                    ),
                    child: Flexible(
                      child: GestureDetector(
                        onTap: () {
                          saveInteraction("PERSONALIZADO_PDF_Atras");
                          _previousPage();
                        },
                        child: Buttons(Icons.chevron_left),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1000,
                  ),
                  Visibility(
                    visible: currentPage < totalPages - 1,
                    replacement: Flexible(
                      child: SizedBox(
                        height: 1,
                        width: MediaQuery.of(context).size.height / 12,
                      ),
                    ),
                    child: Flexible(
                      child: GestureDetector(
                        onTap: () {
                          saveInteraction("PERSONALIZADO_PDF_Adelante");
                          _nextPage();
                        },
                        child: Buttons(Icons.chevron_right),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Visibility(
                        visible: currentPage > 0,
                        replacement: Container(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Atrás",
                              style: TextStyle(
                                fontFamily: 'AtkinsonHyperlegible',
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        "Página ${currentPage + 1}",
                        style: TextStyle(
                          fontFamily: 'AtkinsonHyperlegible',
                          fontSize: MediaQuery.of(context).size.width / 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Visibility(
                        visible: currentPage < totalPages - 1,
                        replacement: Container(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Adelante",
                              style: TextStyle(
                                fontFamily: 'AtkinsonHyperlegible',
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<File?>(
          future: PdfFromUrl(widget.url),
          builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              pdfPath = snapshot.data!.path;

              return Stack(
                children: [
                  if (animateForward)
                    PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 600),
                      reverse: true,
                      transitionBuilder:
                          (child, primaryAnimation, secondaryAnimation) {
                        animation = primaryAnimation;
                        return AnimatedBuilder(
                          animation: primaryAnimation,
                          builder: (context, child) {
                            final double zTranslation =
                                10.0 * (1 - primaryAnimation.value);
                            final double waveRotation =
                                1.6 * (1 - primaryAnimation.value);
                            final double waveTranslation =
                                -400.0 * (1 - primaryAnimation.value);

                            return Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(waveRotation)
                                ..translate(
                                    waveTranslation, 0.0, zTranslation)
                                ..scale(1.0 -
                                    ((1 - primaryAnimation.value) * 0.03)),
                              child: child,
                            );
                          },
                          child: child,
                        );
                      },
                      child: PDFView(
                        key: ValueKey<int>(currentPage),
                        filePath: pdfPath,
                        swipeHorizontal: true,
                        enableSwipe: false,
                        defaultPage: currentPage,
                        fitEachPage: true,
                        fitPolicy: FitPolicy.BOTH,
                        onRender: (pages) {
                          setState(() {
                            totalPages = pages ?? 0;
                          });
                        },
                        onPageChanged: (page, _) {
                          setState(() {
                            currentPage = page ?? 0;
                            animateForward = currentPage > (prevPage ?? 0);
                          });
                        },
                        onViewCreated: (PDFViewController controller) {
                          pdfController = controller;
                        },
                      ),
                    ),
                  if (!animateForward)
                    PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 1200),
                      reverse: false,
                      transitionBuilder:
                          (child, primaryAnimation, secondaryAnimation) {
                        animation = primaryAnimation;
                        return AnimatedBuilder(
                          animation: primaryAnimation,
                          builder: (context, child) {
                            final double zTranslation =
                                10.0 * (1 - primaryAnimation.value);
                            final double waveRotation =
                                1.5 * (1 - primaryAnimation.value);
                            final double waveTranslation =
                                -30.0 * (1 - primaryAnimation.value);

                            return Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(waveRotation)
                                ..translate(
                                    waveTranslation, 0.0, zTranslation)
                                ..scale(1.0 -
                                    ((1 - primaryAnimation.value) * 0.03)),
                              child: child,
                            );
                          },
                          child: child,
                        );
                      },
                      child: PDFView(
                        key: ValueKey<int>(currentPage),
                        filePath: pdfPath,
                        swipeHorizontal: true,
                        enableSwipe: false,
                        defaultPage: currentPage,
                        fitEachPage: true,
                        fitPolicy: FitPolicy.BOTH,
                        onRender: (pages) {
                          setState(() {
                            totalPages = pages ?? 0;
                          });
                        },
                        onPageChanged: (page, _) {
                          setState(() {
                            currentPage = page ?? 0;
                            animateForward = currentPage > (prevPage ?? 0);
                          });
                        },
                        onViewCreated: (PDFViewController controller) {
                          pdfController = controller;
                        },
                      ),
                    ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              // Si hubo error al obtener el PDF, cerrar pantalla
              Future.microtask(() => Navigator.pop(context));
              return const Center(child: CircularProgressIndicator());
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Future<File?> PdfFromUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Error al descargar el PDF: ${response.statusCode}');
    }

    final Directory cacheDir = await getTemporaryDirectory();
    final File pdfFile = File('${cacheDir.path}/temp_pdf.pdf');

    await pdfFile.writeAsBytes(response.bodyBytes);

    return pdfFile;
  } catch (e) {
    debugPrint("Error procesando PDF: $e");
    return null;
  }
}

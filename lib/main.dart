import 'package:aprende_app/screens/caategorias_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AprendeTecApp());
}

class AprendeTecApp extends StatelessWidget {
  const AprendeTecApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF242E74),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aprende sobre tecnología',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFFFDF4F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF242E74),
          foregroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 90,
        ),
      ),
      home: const CategoriasPdfsScreen(),
    );
  }
}

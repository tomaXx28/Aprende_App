// buttons.dart
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final IconData icon;
  final Color? primaryColor;

  const Buttons(this.icon, {super.key, this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.height / 12;

    return Material(
      elevation: 2,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(800),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryColor != null ? Colors.black : Colors.white,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(800),
          gradient: RadialGradient(
            center: const Alignment(-0.25, -0.25),
            focalRadius: 24,
            colors: [
              primaryColor ?? Colors.indigo.shade700,
              primaryColor ?? Colors.indigo.shade800,
            ],
          ),
        ),
        child: Icon(
          icon,
          color: primaryColor != null ? Colors.black : Colors.white,
          size: MediaQuery.of(context).size.height / 23,
        ),
      ),
    );
  }
}

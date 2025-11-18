// screen_base_top_bottom_bar.dart
import 'package:flutter/material.dart';

class CustomerLeading extends StatelessWidget {
  const CustomerLeading({super.key});

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
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
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

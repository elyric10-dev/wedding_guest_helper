import 'package:flutter/material.dart';
import 'package:verifier/screens/scanner_screen.dart';
import 'dart:math';

void main() {
  runApp(const VerifierApp());
}

class VerifierApp extends StatelessWidget {
  const VerifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SeatFinderScreen(),
    );
  }
}

class SeatFinderScreen extends StatelessWidget {
  const SeatFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5E6DA), // Beige background color
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Heading
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcomes!',
                      textAlign: TextAlign.center,
                    ),
                    // const SizedBox(height: 8),
                    Text(
                      'Please scan your QR Code',
                      textAlign: TextAlign.center,
                      // style: GoogleFonts.playfairDisplay(
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.w400,
                      //   color: Colors.black54,
                      // ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Circular QR Scanner
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  const ClipOval(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: ScannerScreen(),
                    ),
                  ),
                ],
              ),
               const SizedBox(height: 40),
              // Instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInstructionColumn(
                        Icons.phone_android,
                        'Prepare your gate pass QR code',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInstructionColumn(
                        Icons.qr_code_scanner,
                        'Place your QR code under the QR scanner',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInstructionColumn(
                        Icons.touch_app,
                        'Check table number and Tap Okay',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Footer
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  'ELYRIC & SANDY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionColumn(IconData icon, String text) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}


class CurvedTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final text = "SCAN TO FIND YOUR SEAT";
    final radius = size.width / 2 - 20; // Adjust padding from the edge
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // Center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Path for the curved text
    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 1.18, // Start angle (top-center of the circle)
        pi, // Sweep angle (half-circle, counter-clockwise)
      );

    // Draw text along the path
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;

    double offset = 0;
    for (int i = 0; i < text.length; i++) {
      final textSpan = TextSpan(text: text[i], style: textStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      final textLength = textPainter.width;

      // Position for the character
      final tangent = metrics.getTangentForOffset(offset + textLength / 2)!;
      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);
      canvas.rotate(tangent.angle + pi); // Rotate 180° to fix reversed text
      textPainter.paint(
          canvas, Offset(-textLength / 2, -textPainter.height / 2));
      canvas.restore();

      offset += textLength;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
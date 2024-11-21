import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:verifier/screens/verification_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late MobileScannerController controller;
  bool hasScanned = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E&S QR Verifier'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (!hasScanned) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes[0].rawValue;
              if (code != null) {
                setState(() {
                  hasScanned = true;
                });
                controller.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationScreen(scannedData: code),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
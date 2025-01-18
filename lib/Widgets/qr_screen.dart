import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {

  final MobileScannerController _cameraController = MobileScannerController();

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              controller: _cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    // Prevent multiple scans
                    if (isStarted) {
                      isStarted = false;
                      Navigator.of(context).pop(code);
                    }
                  }
                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _cameraController;
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlashOn = false;
  MobileScannerController? _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitialize();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  Future<void> _checkPermissionAndInitialize() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
        facing: CameraFacing.back,
      );
      setState(() {});
    } else {
      // Show permission denied message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Camera permission is required to scan QR codes',
              style: GoogleFonts.poppins(),
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              _controller!.toggleTorch();
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller!,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleQRCode(barcode.rawValue!);
                }
              }
            },
          ),
          _buildScanOverlay(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Align QR code within the frame',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scanning will start automatically',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return CustomPaint(
      size: Size.infinite,
      painter: QRScannerOverlayPainter(
        animation: _animation,
        borderColor: Theme.of(context).colorScheme.primary,
        scanLineColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleQRCode(String qrCode) {
    // Stop scanning
    _controller?.stop();

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'QR Code Detected',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'UPI ID: ${qrCode.split('=').last}',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller?.start();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement payment processing(prototype hai leave it)
              Navigator.pop(context);
              Navigator.pushNamed(context, '/payment', arguments: qrCode);
            },
            child: Text(
              'Proceed to Pay',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlayPainter extends CustomPainter {
  final Animation<double> animation;
  final Color borderColor;
  final Color scanLineColor;

  QRScannerOverlayPainter({
    required this.animation,
    required this.borderColor,
    required this.scanLineColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Draw semi-transparent overlay
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate scanner window size and position
    final scannerSize = size.width * 0.7;
    final left = (size.width - scannerSize) / 2;
    final top = (size.height - scannerSize) / 2;

    // Cut out scanner window
    path.addRect(
      Rect.fromLTWH(left, top, scannerSize, scannerSize),
    );
    canvas.drawPath(path, paint);

    // Draw scanner window border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(
      Rect.fromLTWH(left, top, scannerSize, scannerSize),
      borderPaint,
    );

    // Draw corner markers
    final cornerLength = scannerSize * 0.1;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scannerSize - cornerLength, top),
      Offset(left + scannerSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scannerSize, top),
      Offset(left + scannerSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scannerSize - cornerLength),
      Offset(left, top + scannerSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scannerSize),
      Offset(left + cornerLength, top + scannerSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scannerSize - cornerLength, top + scannerSize),
      Offset(left + scannerSize, top + scannerSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scannerSize, top + scannerSize),
      Offset(left + scannerSize, top + scannerSize - cornerLength),
      cornerPaint,
    );

    // Draw scan line
    final scanLinePaint = Paint()
      ..color = scanLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final scanLineY = top + (scannerSize * animation.value);
    canvas.drawLine(
      Offset(left + 16, scanLineY),
      Offset(left + scannerSize - 16, scanLineY),
      scanLinePaint,
    );
  }

  @override
  bool shouldRepaint(QRScannerOverlayPainter oldDelegate) => true;
}

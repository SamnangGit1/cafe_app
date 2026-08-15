import 'package:cafe_app/shared/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum ScanMode { table, order }

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  ScanMode _selectedMode = ScanMode.table;
  bool _isScanning = false;
  bool _hasResult = false;
  String? _scannedValue;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  MobileScannerController? _cameraController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _hasResult = false;
      _scannedValue = null;
    });
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  void _stopScanning() {
    _cameraController?.stop();
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _isScanning = false;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasResult) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final value = barcodes.first.rawValue!;
      _cameraController?.stop();
      setState(() {
        _hasResult = true;
        _scannedValue = value;
        _isScanning = false;
      });
      _showResultSheet(value);
    }
  }

  void _showResultSheet(String value) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _buildResultSheet(value),
    ).then((_) {
      setState(() {
        _hasResult = false;
        _scannedValue = null;
      });
    });
  }

  Widget _buildResultSheet(String value) {
    final isTable = _selectedMode == ScanMode.table;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.clay.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.espresso,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isTable ? Iconsax.grid_1 : Iconsax.receipt_edit,
              color: AppColors.caramel,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isTable ? 'Table Scanned!' : 'Order Scanned!',
            style: GoogleFonts.fraunces(
              color: AppColors.espresso,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTable
                ? 'QR code recognized. Linking to table...'
                : 'QR code recognized. Loading order...',
            style: GoogleFonts.inter(
              color: AppColors.clay,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.caramel.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTable ? 'TABLE CODE' : 'ORDER CODE',
                  style: GoogleFonts.inter(
                    color: AppColors.clay,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.fraunces(
                    color: AppColors.espresso,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.espresso,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  isTable ? 'Seat at Table' : 'View Order',
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.sand,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.caramel.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  'Scan Again',
                  style: GoogleFonts.inter(
                    color: AppColors.espresso,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.espresso.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildModeButton(
            mode: ScanMode.table,
            icon: Iconsax.grid_1,
            label: 'Scan Table',
          ),
          _buildModeButton(
            mode: ScanMode.order,
            icon: Iconsax.receipt_edit,
            label: 'Scan Order',
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required ScanMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!_isScanning) {
            setState(() => _selectedMode = mode);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.espresso : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.caramel : AppColors.espresso,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? AppColors.white : AppColors.espresso,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanViewFinder() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (_, _) => Transform.scale(
        scale: _pulseAnimation.value,
        child: SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            children: [
              // Top-left
              Positioned(
                top: 0, left: 0,
                child: _buildCorner(topLeft: true),
              ),
              // Top-right
              Positioned(
                top: 0, right: 0,
                child: _buildCorner(topRight: true),
              ),
              // Bottom-left
              Positioned(
                bottom: 0, left: 0,
                child: _buildCorner(bottomLeft: true),
              ),
              // Bottom-right
              Positioned(
                bottom: 0, right: 0,
                child: _buildCorner(bottomRight: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return CustomPaint(
      size: const Size(36, 36),
      painter: _CornerPainter(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Camera feed or dark preview ──────────────────────────────────
          if (_isScanning && _cameraController != null)
            Positioned.fill(
              child: MobileScanner(
                controller: _cameraController!,
                onDetect: _onDetect,
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: const Color(0xFF0F0F0F),
              ),
            ),

          // ── Dark gradient overlays ──────────────────────────────────────
          Positioned.fill(
            child: Column(
              children: [
                // Top fade
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Bottom fade
                Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Safe area UI ────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Top header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scan',
                        style: GoogleFonts.fraunces(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0),
                      if (_isScanning)
                        GestureDetector(
                          onTap: _stopScanning,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Scanner viewfinder ────────────────────────────────────
                _buildScanViewFinder().animate().fade(duration: 500.ms, delay: 100.ms).scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                ),

                const SizedBox(height: 24),

                // ── Hint label ────────────────────────────────────────────
                Text(
                  _isScanning
                      ? (_selectedMode == ScanMode.table
                          ? 'Point at the table QR code'
                          : 'Point at the order QR code')
                      : 'Choose a mode and tap Scan',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fade(duration: 400.ms, delay: 150.ms),

                const Spacer(),

                // ── Mode selector ─────────────────────────────────────────
                _buildModeSelector().animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),

                // ── Scan button ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: _isScanning ? _stopScanning : _startScanning,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _isScanning
                            ? Colors.white.withOpacity(0.15)
                            : AppColors.caramel,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isScanning
                                  ? Icons.stop_rounded
                                  : Iconsax.scan,
                              color: _isScanning
                                  ? Colors.white
                                  : AppColors.espresso,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isScanning ? 'Stop Scanning' : 'Start Scanning',
                              style: GoogleFonts.inter(
                                color: _isScanning
                                    ? Colors.white
                                    : AppColors.espresso,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fade(duration: 400.ms, delay: 250.ms).slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 28.0;
    const r = 8.0;

    final Path path = Path();
    if (topLeft) {
      path.moveTo(0, len);
      path.lineTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: const Radius.circular(r));
      path.lineTo(len, 0);
    } else if (topRight) {
      path.moveTo(size.width - len, 0);
      path.lineTo(size.width - r, 0);
      path.arcToPoint(Offset(size.width, r), radius: const Radius.circular(r));
      path.lineTo(size.width, len);
    } else if (bottomLeft) {
      path.moveTo(0, size.height - len);
      path.lineTo(0, size.height - r);
      path.arcToPoint(Offset(r, size.height), radius: const Radius.circular(r));
      path.lineTo(len, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width - len, size.height);
      path.lineTo(size.width - r, size.height);
      path.arcToPoint(Offset(size.width, size.height - r),
          radius: const Radius.circular(r));
      path.lineTo(size.width, size.height - len);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

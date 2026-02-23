import 'package:flutter/material.dart';
import '../services/barcode_scan_runner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final BarcodeScanRunner _runner = BarcodeScanRunner.instance;
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocus = FocusNode();
  bool _prepared = false;
  String? _error;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      await _runner.prepare();
      if (!mounted) return;
      setState(() {
        _prepared = true;
        _error = null;
      });
      _runner.runLiveScan(_onBarcode);
    } catch (e) {
      if (mounted) {
        setState(() {
          _prepared = false;
          _error = e is StateError ? e.message : 'Could not start camera';
        });
      }
    }
  }

  void _onBarcode(String value) {
    if (!mounted) return;
    Navigator.pop(context, value);
  }

  Future<void> _toggleTorch() async {
    final on = !_torchOn;
    final result = await _runner.setTorch(on);
    if (mounted) setState(() => _torchOn = result);
  }

  Future<void> _pickFromGallery() async {
    final value = await _runner.scanFromGallery();
    if (!mounted) return;
    if (value != null) {
      Navigator.pop(context, value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No barcode found in the image'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildManualBarcodeEntry() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.75)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Or enter barcode',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeController,
                    focusNode: _barcodeFocus,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'e.g. 614969230905',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitTypedBarcode(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submitTypedBarcode,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Look up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitTypedBarcode() {
    final value = _barcodeController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a barcode'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocus.dispose();
    _runner.stopLiveScan();
    _runner.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Barcode'),
        actions: [
          if (_prepared) ...[
            IconButton(
              icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleTorch,
            ),
            IconButton(
              icon: const Icon(Icons.photo_library_outlined),
              onPressed: _pickFromGallery,
              tooltip: 'Scan from gallery',
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() => _error = null);
                        _start();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            _buildManualBarcodeEntry(),
          ],
        ),
      );
    }

    if (!_prepared) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _runner.previewWidget,
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Point the camera at a barcode',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ),
        // manually enter
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildManualBarcodeEntry(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  CameraController? _controller;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller?.initialize();
    _controller?.startImageStream(_processCameraImage);
    if (mounted) setState(() {});
  }

  void _processCameraImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      final inputImage = _convertImage(image);
      final List<Barcode> barcodes = await _barcodeScanner.processImage(
        inputImage,
      );

      for (Barcode barcode in barcodes) {
        if (barcode.rawValue != null) {
          debugPrint('Scanned: ${barcode.rawValue}');
          await _lookupProduct(barcode.rawValue!);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    _isBusy = false;
  }

  Future<void> _lookupProduct(String code) async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('products')
        .select()
        .eq('extracted_barcode', code)
        .maybeSingle();

    if (data != null && mounted) {
      _controller?.stopImageStream();
      _showProductSheet(data);
    }
  }

  void _showProductSheet(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['product_name'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text("Type: ${product['product_type']}"),
            Text(
              "Price: ${product['price']}",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("Ingredients:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(product['ingredients']),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controller?.startImageStream(_processCameraImage);
                },
                child: Text("Scan Another Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputImage _convertImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation90deg, // Adjust if scan is sideways
      format:
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  Widget build(BuildContext context) {
    // This part tells Flutter to show the camera feed on the screen
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("SkinSync Scanner")),
      body: Stack(
        children: [
          CameraPreview(_controller!), // The live camera view
          const Center(
            child: Icon(
              Icons.qr_code_scanner,
              size: 200,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

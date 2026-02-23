import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class IngredientScanScreen extends StatefulWidget {
  const IngredientScanScreen({super.key});

  static const primary = Color(0xFF4D123F);
  static const background = Color(0xFFF7F4F8);

  @override
  State<IngredientScanScreen> createState() => _IngredientScanScreenState();
}

class _IngredientScanScreenState extends State<IngredientScanScreen> {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  final ImagePicker _picker = ImagePicker();

  String? _extractedText;
  List<String> _detectedIngredients = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _error = 'Camera permission is required');
        return;
      }
    }

    setState(() {
      _loading = true;
      _error = null;
      _extractedText = null;
      _detectedIngredients = [];
    });

    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (file == null || !mounted) {
        setState(() => _loading = false);
        return;
      }

      final inputImage = InputImage.fromFilePath(file.path);
      final recognized = await _recognizer.processImage(inputImage);
      final text = recognized.text.trim();

      if (!mounted) return;

      if (text.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No text found. Try a clearer image of the ingredient list.';
        });
        return;
      }

      final ingredients = _parseIngredientInfo(text);

      setState(() {
        _extractedText = text;
        _detectedIngredients = ingredients;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not read text. Try again with a clearer image.';
        });
      }
    }
  }

  List<String> _parseIngredientInfo(String text) {
    final lower = text.toLowerCase();
    const keywords = [
      'vitamin c',
      'ascorbic acid',
      'niacinamide',
      'retinol',
      'retinal',
      'hyaluronic acid',
      'hyaluronate',
      'salicylic acid',
      'aha',
      'bha',
      'glycolic acid',
      'lactic acid',
      'peptide',
      'ceramide',
      'spf',
      'sunscreen',
      'zinc oxide',
      'titanium dioxide',
      'alpha arbutin',
      'kojic acid',
      'tranexamic acid',
      'centella',
      'cica',
      'panthenol',
      'vitamin e',
      'tocopherol',
      'squalane',
      'glycerin',
      'aloe',
    ];
    final found = <String>{};
    for (final k in keywords) {
      if (lower.contains(k)) found.add(k);
    }
    return found.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IngredientScanScreen.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: IngredientScanScreen.primary,
        elevation: 0,
        title: const Text('Ingredient Scan'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: IngredientScanScreen.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_extractedText == null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Scan ingredient list',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: IngredientScanScreen.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo or choose from gallery to extract ingredients and see product info.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),
                    _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Take photo',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 12),
                    _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Choose from gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ] else ...[
                    _ResultCard(
                      title: 'Detected ingredients',
                      content: _extractedText!,
                    ),
                    const SizedBox(height: 20),
                    if (_detectedIngredients.isNotEmpty)
                      _ResultCard(
                        title: 'Product info (key ingredients)',
                        content: _detectedIngredients.join(', '),
                        isHighlight: true,
                      ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Scan another'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: IngredientScanScreen.primary,
                        side: const BorderSide(
                          color: IngredientScanScreen.primary,
                        ),
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: IngredientScanScreen.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 28, color: IngredientScanScreen.primary),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IngredientScanScreen.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isHighlight;

  const _ResultCard({
    required this.title,
    required this.content,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight
            ? IngredientScanScreen.primary.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IngredientScanScreen.primary.withOpacity(
            isHighlight ? 0.2 : 0.12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: IngredientScanScreen.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: isHighlight ? Colors.black87 : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

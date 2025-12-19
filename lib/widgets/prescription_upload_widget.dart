import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../l10n/app_localizations.dart';

class PrescriptionUploadWidget extends StatefulWidget {
  final Function(File? imageFile, Uint8List? webImage) onImageSelected;
  final String? currentImagePath;
  final String? loadedPrescriptionName;

  const PrescriptionUploadWidget({
    super.key,
    required this.onImageSelected,
    this.currentImagePath,
    this.loadedPrescriptionName,
  });

  @override
  State<PrescriptionUploadWidget> createState() =>
      _PrescriptionUploadWidgetState();
}

class _PrescriptionUploadWidgetState extends State<PrescriptionUploadWidget> {
  File? _imageFile;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _imageFile = null;
          });
          widget.onImageSelected(null, bytes);
        } else {
          final file = File(pickedFile.path);
          setState(() {
            _imageFile = file;
            _webImage = null;
          });
          widget.onImageSelected(file, null);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.invalidPrescription),
          content: Text(
            AppLocalizations.of(context)!.invalidPrescriptionMessage,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.chooseFromGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.takePhoto),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_webImage != null) {
      return Image.memory(
        _webImage!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (widget.currentImagePath != null) {
      return Image.network(
        widget.currentImagePath!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    } else if (widget.loadedPrescriptionName != null) {
      // Show loaded prescription indicator
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E7D32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description, size: 48, color: Color(0xFF2E7D32)),
            const SizedBox(height: 8),
            Text(
              'Previous Prescription Loaded',
              style: TextStyle(
                color: const Color(0xFF2E7D32),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.loadedPrescriptionName!,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.uploadPrescription,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.upload),
            label: Text(l10n.uploadPrescription),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Image Preview
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildImagePreview(),
        ),

        const SizedBox(height: 12),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.prescriptionDisclaimer,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

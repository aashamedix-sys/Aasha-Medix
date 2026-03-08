import 'dart:io';

class FileValidator {
  static const int maxPdfSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedPdfExtensions = ['pdf'];
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  /// Validates a PDF file for upload (reports, prescriptions).
  /// Returns null if valid, or an error message string if invalid.
  static String? validatePdf(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (!allowedPdfExtensions.contains(ext)) {
      return 'Only PDF files are allowed. Selected: .$ext';
    }

    final size = file.lengthSync();
    if (size > maxPdfSizeBytes) {
      final sizeMb = (size / (1024 * 1024)).toStringAsFixed(1);
      return 'File is too large (${sizeMb}MB). Maximum allowed is 10MB.';
    }

    if (size == 0) {
      return 'The selected file is empty. Please choose a valid PDF.';
    }

    return null; // Valid
  }

  /// Validates an image file for upload (profile photos, etc.).
  /// Returns null if valid, or an error message string if invalid.
  static String? validateImage(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (!allowedImageExtensions.contains(ext)) {
      return 'Only JPG/PNG images are allowed. Selected: .$ext';
    }

    final size = file.lengthSync();
    if (size > maxImageSizeBytes) {
      final sizeMb = (size / (1024 * 1024)).toStringAsFixed(1);
      return 'Image is too large (${sizeMb}MB). Maximum allowed is 5MB.';
    }

    if (size == 0) {
      return 'The selected image is empty. Please choose a valid image.';
    }

    return null; // Valid
  }
}

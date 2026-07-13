import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class FileExportService {
  /// Exports and saves a file, handling both Web and Desktop automatically.
  /// On Web, providing [bytes] to [FilePicker.platform.saveFile] will trigger
  /// a browser download instantly and return null.
  /// On Desktop, it will ask the user for a path, and we must write the bytes manually.
  static Future<String?> exportAndSave({
    required Uint8List bytes,
    required String fileName,
    required String extension,
    required String dialogTitle,
  }) async {
    String? path = await FilePicker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension],
      bytes: kIsWeb ? bytes : null,
    );

    if (!kIsWeb && path != null) {
      if (!path.endsWith('.$extension')) {
        path += '.$extension';
      }
      final file = File(path);
      await file.writeAsBytes(bytes);
      return path;
    }
    
    // On web, path is null but the file was downloaded successfully.
    return kIsWeb ? fileName : path;
  }
}

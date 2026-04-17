// save_and_open_documents.dart
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SaveAndOpenDocuments {
  /// Save the pdf document to a temporary file and return the File.
  static Future<File> savePdf({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Save and open
  static Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }
}

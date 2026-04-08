import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<Directory> _getReceiptDirectory() async {
  final downloadsDirectory = await getDownloadsDirectory();
  if (downloadsDirectory != null) {
    final directory = Directory(
      '${downloadsDirectory.path}${Platform.pathSeparator}Sales System${Platform.pathSeparator}Receipts',
    );
    await directory.create(recursive: true);
    return directory;
  }

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final directory = Directory(
    '${documentsDirectory.path}${Platform.pathSeparator}Sales System${Platform.pathSeparator}Receipts',
  );
  await directory.create(recursive: true);
  return directory;
}

Future<String?> saveReceiptPdf(Uint8List bytes) async {
  final directory = await _getReceiptDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File(
    '${directory.path}${Platform.pathSeparator}sale_receipt_$timestamp.pdf',
  );
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

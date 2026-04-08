import 'dart:typed_data';

import 'receipt_pdf_saver_stub.dart'
    if (dart.library.io) 'receipt_pdf_saver_io.dart'
    if (dart.library.html) 'receipt_pdf_saver_web.dart' as impl;

Future<String?> saveReceiptPdf(Uint8List bytes) => impl.saveReceiptPdf(bytes);

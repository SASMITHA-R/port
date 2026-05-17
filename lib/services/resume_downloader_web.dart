import 'dart:js_interop';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

Future<void> downloadResumeImpl() async {
  const assetPath = 'assets/Sasmitha_R_Resume.pdf';
  const fileName = 'Sasmitha_R_Resume.pdf';

  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();

  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..setAttribute('download', fileName)
    ..style.display = 'none';

  web.document.body!.appendChild(anchor);
  anchor.click();
  web.document.body!.removeChild(anchor);
  web.URL.revokeObjectURL(url);

}

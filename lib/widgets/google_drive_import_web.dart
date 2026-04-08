import 'dart:async';
import 'dart:html' as html;

Future<String?> _readBlobAsDataUrl(html.Blob blob) {
  final completer = Completer<String?>();
  final reader = html.FileReader();

  reader.onLoad.listen((_) {
    final result = reader.result;
    completer.complete(result is String ? result : null);
  });
  reader.onError.listen((_) {
    completer.complete(null);
  });

  reader.readAsDataUrl(blob);
  return completer.future;
}

Future<String?> importGoogleDriveImageAsDataUrl(List<String> candidates) async {
  for (final candidate in candidates) {
    final trimmed = candidate.trim();
    if (trimmed.isEmpty) continue;

    try {
      final response = await html.HttpRequest.request(
        trimmed,
        method: 'GET',
        responseType: 'blob',
      ).timeout(const Duration(seconds: 15));

      final blob = response.response;
      if (response.status == 200 && blob is html.Blob) {
        final mimeType = blob.type;
        if (mimeType.startsWith('image/')) {
          final dataUrl = await _readBlobAsDataUrl(blob);
          if (dataUrl != null && dataUrl.startsWith('data:image/')) {
            return dataUrl;
          }
        }
      }
    } catch (_) {
      continue;
    }
  }

  return null;
}

String? extractGoogleDriveFileId(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;

  final filePathMatch = RegExp(r'drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)')
      .firstMatch(trimmed);
  if (filePathMatch != null) {
    return filePathMatch.group(1);
  }

  final openIdMatch =
      RegExp(r'[?&]id=([a-zA-Z0-9_-]+)').firstMatch(trimmed);
  if (openIdMatch != null) {
    return openIdMatch.group(1);
  }

  final ucPathMatch =
      RegExp(r'(?:docs|drive)\.google\.com\/uc\?.*?[?&]id=([a-zA-Z0-9_-]+)')
          .firstMatch(trimmed);
  if (ucPathMatch != null) {
    return ucPathMatch.group(1);
  }

  return null;
}

bool isGoogleDriveImageUrl(String url) {
  return extractGoogleDriveFileId(url) != null;
}

List<String> googleDriveImageCandidates(String url) {
  final fileId = extractGoogleDriveFileId(url);
  if (fileId == null || fileId.isEmpty) {
    return [url.trim()];
  }

  return [
    'https://drive.usercontent.google.com/download?id=$fileId&export=view&authuser=0',
    'https://drive.usercontent.google.com/uc?id=$fileId&export=view&authuser=0',
    'https://drive.google.com/thumbnail?id=$fileId&sz=w2000',
    'https://drive.google.com/uc?export=view&id=$fileId',
    'https://drive.google.com/uc?export=download&id=$fileId',
    'https://lh3.googleusercontent.com/d/$fileId=w2000',
    'https://lh3.googleusercontent.com/u/0/d/$fileId=w2000',
  ];
}

String normalizeImageUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty || trimmed.startsWith('data:image/')) {
    return trimmed;
  }

  final googleDriveFileId = extractGoogleDriveFileId(trimmed);
  if (googleDriveFileId != null && googleDriveFileId.isNotEmpty) {
    return 'https://drive.usercontent.google.com/download?id=$googleDriveFileId&export=view&authuser=0';
  }

  return trimmed;
}

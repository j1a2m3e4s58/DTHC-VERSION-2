import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class StoreImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Alignment alignment;

  const StoreImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.errorWidget,
    this.alignment = Alignment.center,
  });

  bool get _isEmbeddedImage => imageUrl.trim().startsWith('data:image/');

  Uint8List? _decodeEmbeddedBytes() {
    if (!_isEmbeddedImage) return null;
    final commaIndex = imageUrl.indexOf(',');
    if (commaIndex == -1) return null;

    try {
      return base64Decode(imageUrl.substring(commaIndex + 1));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _decodeEmbeddedBytes();
    Widget child;

    if (_isEmbeddedImage && bytes != null) {
      child = Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? const SizedBox.shrink(),
      );
    } else {
      child = Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? const SizedBox.shrink(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    return child;
  }
}

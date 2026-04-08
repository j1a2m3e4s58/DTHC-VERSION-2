import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/image_url_utils.dart';
import 'web_network_image_stub.dart'
    if (dart.library.html) 'web_network_image_web.dart' as web_network_image;

class StoreImage extends StatefulWidget {
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

  @override
  State<StoreImage> createState() => _StoreImageState();
}

class _StoreImageState extends State<StoreImage> {
  late List<String> _networkCandidates;
  int _candidateIndex = 0;

  bool get _isEmbeddedImage => widget.imageUrl.trim().startsWith('data:image/');

  @override
  void initState() {
    super.initState();
    _resetCandidates();
  }

  @override
  void didUpdateWidget(covariant StoreImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _resetCandidates();
    }
  }

  void _resetCandidates() {
    _networkCandidates = googleDriveImageCandidates(widget.imageUrl)
        .map(normalizeImageUrl)
        .where((candidate) => candidate.isNotEmpty)
        .toSet()
        .toList();
    _candidateIndex = 0;
  }

  Uint8List? _decodeEmbeddedBytes() {
    if (!_isEmbeddedImage) return null;
    final commaIndex = widget.imageUrl.indexOf(',');
    if (commaIndex == -1) return null;

    try {
      return base64Decode(widget.imageUrl.substring(commaIndex + 1));
    } catch (_) {
      return null;
    }
  }

  void _handleNetworkError() {
    if (_candidateIndex >= _networkCandidates.length - 1) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _candidateIndex += 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _isEmbeddedImage
        ? _decodeEmbeddedBytes()
        : null;
    Widget child;

    if (_isEmbeddedImage && bytes != null) {
      child = Image.memory(
        bytes,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        errorBuilder: (context, error, stackTrace) =>
            widget.errorWidget ?? const SizedBox.shrink(),
      );
    } else {
      final activeUrl = _networkCandidates.isEmpty
          ? normalizeImageUrl(widget.imageUrl)
          : _networkCandidates[_candidateIndex.clamp(0, _networkCandidates.length - 1)];
      final webDriveImage = isGoogleDriveImageUrl(widget.imageUrl)
          ? web_network_image.buildWebNetworkImage(
              imageUrl: activeUrl,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
              borderRadius: widget.borderRadius,
            )
          : null;
      if (webDriveImage != null) {
        child = webDriveImage;
      } else {
        child = Image.network(
          activeUrl,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          alignment: widget.alignment,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            _handleNetworkError();
            return widget.errorWidget ?? const SizedBox.shrink();
          },
        );
      }
    }

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: child,
      );
    }

    return child;
  }
}

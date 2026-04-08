import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

import '../utils/image_url_utils.dart';

final Set<String> _registeredWebImageViews = <String>{};

String _boxFitToCss(BoxFit fit) {
  switch (fit) {
    case BoxFit.contain:
      return 'contain';
    case BoxFit.fill:
      return 'fill';
    case BoxFit.fitHeight:
      return 'contain';
    case BoxFit.fitWidth:
      return 'contain';
    case BoxFit.none:
      return 'none';
    case BoxFit.scaleDown:
      return 'scale-down';
    case BoxFit.cover:
    default:
      return 'cover';
  }
}

Widget? buildWebNetworkImage({
  required String imageUrl,
  required BoxFit fit,
  double? width,
  double? height,
  BorderRadius? borderRadius,
}) {
  final sanitizedUrl = imageUrl.trim();
  if (sanitizedUrl.isEmpty) return null;
  final googleDriveFileId = extractGoogleDriveFileId(sanitizedUrl);

  final viewType = googleDriveFileId != null
      ? 'drive-preview-$googleDriveFileId'
      : 'network-image-${sanitizedUrl.hashCode}-${_boxFitToCss(fit)}';
  if (!_registeredWebImageViews.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      final element = googleDriveFileId != null
          ? (html.IFrameElement()
            ..src = 'https://drive.google.com/file/d/$googleDriveFileId/preview'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.border = '0'
            ..setAttribute('allow', 'autoplay'))
          : (html.ImageElement()
            ..src = sanitizedUrl
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = _boxFitToCss(fit)
            ..style.display = 'block');

      if (borderRadius != null) {
        element.style.borderRadius = '${borderRadius.topLeft.x}px';
      }

      return element;
    });
    _registeredWebImageViews.add(viewType);
  }

  Widget child = HtmlElementView(viewType: viewType);

  if (width != null || height != null) {
    child = SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  if (borderRadius != null) {
    child = ClipRRect(
      borderRadius: borderRadius,
      child: child,
    );
  }

  return child;
}

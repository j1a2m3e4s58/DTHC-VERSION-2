import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminImageUploadField extends StatefulWidget {
  final TextEditingController controller;
  final String storageFolder;
  final InputDecoration decoration;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final int maxLines;
  final Color buttonForegroundColor;
  final Color? buttonBackgroundColor;
  final Color? buttonBorderColor;
  final String uploadButtonLabel;
  final String helperText;

  const AdminImageUploadField({
    super.key,
    required this.controller,
    required this.storageFolder,
    required this.decoration,
    required this.buttonForegroundColor,
    this.style,
    this.validator,
    this.maxLines = 1,
    this.buttonBackgroundColor,
    this.buttonBorderColor,
    this.uploadButtonLabel = 'Upload from device',
    this.helperText = 'Paste an image URL or upload one from your device.',
  });

  @override
  State<AdminImageUploadField> createState() => _AdminImageUploadFieldState();
}

class _AdminImageUploadFieldState extends State<AdminImageUploadField> {
  late final TextEditingController _displayController;
  bool _isPicking = false;

  bool get _hasEmbeddedImage => widget.controller.text.startsWith('data:image/');

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    _syncDisplayValue();
    widget.controller.addListener(_syncDisplayValue);
  }

  @override
  void didUpdateWidget(covariant AdminImageUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncDisplayValue);
      widget.controller.addListener(_syncDisplayValue);
      _syncDisplayValue();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncDisplayValue);
    _displayController.dispose();
    super.dispose();
  }

  void _syncDisplayValue() {
    final sourceValue = widget.controller.text;
    final nextDisplayValue = sourceValue.startsWith('data:image/')
        ? '[Image uploaded from device]'
        : sourceValue;

    if (_displayController.text != nextDisplayValue) {
      _displayController.value = TextEditingValue(
        text: nextDisplayValue,
        selection: TextSelection.collapsed(offset: nextDisplayValue.length),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  String _buildDataUrl(Uint8List bytes, String? mimeType) {
    final resolvedMimeType = (mimeType == null || mimeType.isEmpty)
        ? 'image/jpeg'
        : mimeType;
    return 'data:$resolvedMimeType;base64,${base64Encode(bytes)}';
  }

  Uint8List? _embeddedImageBytes() {
    final value = widget.controller.text;
    if (!value.startsWith('data:image/')) return null;

    final commaIndex = value.indexOf(',');
    if (commaIndex == -1) return null;

    try {
      return base64Decode(value.substring(commaIndex + 1));
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickImageFromDevice() async {
    if (_isPicking) return;

    try {
      setState(() {
        _isPicking = true;
      });

      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1400,
        maxHeight: 1400,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();
      widget.controller.text = _buildDataUrl(bytes, image.mimeType);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image added from device successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add image from device: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.buttonBorderColor ?? widget.buttonForegroundColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _displayController,
          maxLines: _hasEmbeddedImage ? 1 : widget.maxLines,
          readOnly: _hasEmbeddedImage,
          style: widget.style,
          validator: (_) => widget.validator?.call(widget.controller.text),
          onChanged: (value) {
            widget.controller.text = value;
          },
          decoration: widget.decoration.copyWith(
            suffixIcon: _hasEmbeddedImage
                ? IconButton(
                    tooltip: 'Clear embedded image',
                    onPressed: () {
                      widget.controller.clear();
                    },
                    icon: Icon(
                      Icons.close,
                      color: widget.buttonForegroundColor,
                    ),
                  )
                : widget.decoration.suffixIcon,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _isPicking ? null : _pickImageFromDevice,
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.buttonForegroundColor,
                backgroundColor: widget.buttonBackgroundColor,
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              icon: _isPicking
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.buttonForegroundColor,
                        ),
                      ),
                    )
                  : const Icon(Icons.upload_file_outlined, size: 18),
              label: Text(_isPicking ? 'Adding image...' : widget.uploadButtonLabel),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                _hasEmbeddedImage
                    ? 'Image is currently coming from this device upload.'
                    : widget.helperText,
                style: widget.style?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ) ??
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPreviewSection(),
      ],
    );
  }

  Widget _buildPreviewSection() {
    final value = widget.controller.text.trim();
    final embeddedBytes = _embeddedImageBytes();

    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _openPreviewDialog(value, embeddedBytes),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.buttonBorderColor ?? widget.buttonForegroundColor,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  embeddedBytes != null
                      ? Image.memory(
                          embeddedBytes,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: widget.buttonForegroundColor,
                                size: 28,
                              ),
                            );
                          },
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      color: Colors.black54,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.open_in_full,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Preview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: _isPicking ? null : _pickImageFromDevice,
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.buttonForegroundColor,
                side: BorderSide(
                  color: widget.buttonBorderColor ?? widget.buttonForegroundColor,
                ),
              ),
              icon: const Icon(Icons.sync_alt, size: 18),
              label: const Text('Replace image'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                widget.controller.clear();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Remove image'),
            ),
          ],
        ),
      ],
    );
  }

  void _openPreviewDialog(String value, Uint8List? embeddedBytes) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 760,
              maxHeight: 760,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.buttonBorderColor ?? widget.buttonForegroundColor,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: embeddedBytes != null
                          ? Image.memory(
                              embeddedBytes,
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              value,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.black12,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: widget.buttonForegroundColor,
                                    size: 42,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

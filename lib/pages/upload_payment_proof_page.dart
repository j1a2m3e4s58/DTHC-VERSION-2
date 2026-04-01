import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/order_controller.dart';
import '../data/theme_controller.dart';

class UploadPaymentProofPage extends StatefulWidget {
  final String orderId;
  final String trackingCode;
  final String paymentMethod;

  const UploadPaymentProofPage({
    super.key,
    required this.orderId,
    required this.trackingCode,
    required this.paymentMethod,
  });

  @override
  State<UploadPaymentProofPage> createState() => _UploadPaymentProofPageState();
}

class _UploadPaymentProofPageState extends State<UploadPaymentProofPage> {
  Uint8List? _selectedBytes;
  String? _selectedFileName;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;
      setState(() {
        _selectedBytes = bytes;
        _selectedFileName = image.name;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not select image: $e')),
      );
    }
  }

  Future<void> _uploadProof() async {
  if (_selectedBytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a payment screenshot first.'),
      ),
    );
    return;
  }

  if (_isUploading) return;

  setState(() {
    _isUploading = true;
  });

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('paymentProofs')
        .child('${widget.orderId}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    final uploadTask = storageRef.putData(_selectedBytes!, metadata);

    uploadTask.snapshotEvents.listen((snapshot) {
      if (snapshot.state == TaskState.error && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload failed while sending file to Firebase Storage.'),
          ),
        );
      }
    });

    await uploadTask.timeout(const Duration(seconds: 60));

    final downloadUrl = await storageRef.getDownloadURL();

    if (!mounted) return;

    await context.read<OrderController>().updatePaymentProof(
          orderId: widget.orderId,
          paymentProofUrl: downloadUrl,
          paymentProofStatus: 'Pending Review',
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment proof uploaded successfully.'),
      ),
    );

    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload failed: $e')),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final palette =
        AppColors.palette(context.watch<ThemeController>().isDarkMode);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.card,
        foregroundColor: palette.textPrimary,
        title: const Text(
          'Upload Payment Proof',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 18 : 28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 18 : 22),
                decoration: BoxDecoration(
                  color: palette.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload your payment screenshot',
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tracking Code: ${widget.trackingCode}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payment Method: ${widget.paymentMethod}',
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: palette.border),
                      ),
                      child: Text(
                        'Select a clear screenshot of your Mobile Money or bank transfer payment confirmation. Admin will review it from the dashboard.',
                        style: TextStyle(
                          color: palette.textSecondary,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: isMobile ? 240 : 320,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: palette.border),
                      ),
                      child: _selectedBytes == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 52,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No screenshot selected yet',
                                  style: TextStyle(
                                    color: palette.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                _selectedBytes!,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    if (_selectedFileName != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Selected file: $_selectedFileName',
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isUploading ? null : _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.primaryBlack,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text(
                            'Select Screenshot',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isUploading ? null : _uploadProof,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: _isUploading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.gold,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload_outlined),
                          label: Text(
                            _isUploading
                                ? 'Uploading...'
                                : 'Upload Payment Proof',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/document/bloc/document_bloc.dart';

class DocumentResponseSheet extends StatefulWidget {
  final DocumentItem documentItem;

  const DocumentResponseSheet({super.key, required this.documentItem});

  @override
  State<DocumentResponseSheet> createState() => _DocumentResponseSheetState();
}

class _DocumentResponseSheetState extends State<DocumentResponseSheet> {
  File? _selectedFile;
  final TextEditingController _descController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("select_source".tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text("camera".tr()),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text("gallery".tr()),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: source, imageQuality: 85);
    if (xFile != null) {
      setState(() => _selectedFile = File(xFile.path));
    }
  }

  void _submit() {
    if (_selectedFile == null || widget.documentItem.id == null) return;

    context.read<DocumentBloc>().add(RespondToRequest(
      requestId: widget.documentItem.id!,
      file: _selectedFile!,
      description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, DocumentState>(
      listenWhen: (prev, curr) => prev.respondStatus != curr.respondStatus,
      listener: (context, state) {
        if (state.respondStatus == NetworkStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("document_uploaded_successfully".tr()),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.respondStatus == NetworkStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("upload_failed".tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upload_file, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${"respond_to".tr()}: ${widget.documentItem.docTypeName ?? ''}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // File picker
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedFile != null ? Colors.green : Colors.grey.shade300,
                    width: _selectedFile != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade50,
                ),
                child: _selectedFile != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFile!.path.split('/').last,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: _pickFile,
                            child: Text("change_file".tr(), style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 36, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            "tap_to_select_file".tr(),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            "PDF, JPG, PNG · Max 10MB",
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "add_description_optional".tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            // Submit button
            BlocBuilder<DocumentBloc, DocumentState>(
              buildWhen: (prev, curr) => prev.respondStatus != curr.respondStatus,
              builder: (context, state) {
                _isUploading = state.respondStatus == NetworkStatus.loading;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedFile == null || _isUploading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text("submit_response".tr(), style: const TextStyle(fontSize: 15)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import '../../Config/themes/text_styles.dart';
import '../../Config/themes/app_colors.dart';
import '../../Controller/locale/localization_service_controller.dart';

void showImageSourceDialog(BuildContext context,
    {Function? onTapCamera,
    Function? onTapGallery,
    Function? onTapFile,
    String title = 'Upload Image',
    bool isFilePicker = false,
    bool isCameraPicker = true,
    bool askForFilename = false}) {
  // If isFilePicker is true, onTapFile must not be null
  assert(!isFilePicker || onTapFile != null,
      'onTapFile must not be null when isFilePicker is true');

  // Capture the text style before showing the dialog to avoid context issues
  final titleStyle =
      AppTextStyle.titleSmall;

  // Store callbacks locally to avoid context issues after widget disposal
  final localOnTapCamera = onTapCamera;
  final localOnTapGallery = onTapGallery;
  final localOnTapFile = onTapFile;

  // Helper function to handle image selection with filename
  void handleImageSelection(Function? callback) async {
    // Navigator.of(context).pop();

    if (callback != null) {
      if (askForFilename) {
        // Show filename dialog first
        // final filename = await showFilenameDialog(context);
        final filename = null;
        if (filename != null && filename.isNotEmpty) {
          // Call the callback with the filename
          if (callback is Function(String?)) {
            callback(filename);
          } else {
            // Try to call the function with the filename parameter if possible
            try {
              callback(filename: filename);
            } catch (e) {
              // If that fails, call it without parameters
              callback();
            }
          }
        } else {
          // If no filename provided, call without filename
          callback();
        }
      } else {
        // Just call the callback without asking for filename
        callback();
      }
    }
  }

  // If isFilePicker is true, we'll only show the file option
  // If isFilePicker is false, we'll show the camera and gallery options, and optionally the file option
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isFilePicker && isCameraPicker)
                    _buildImagePickerOption(
                      icon: Icons.photo_camera,
                      label: tr.camera,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        handleImageSelection(localOnTapCamera);
                      },
                    ),
                  if (!isFilePicker)
                    _buildImagePickerOption(
                      icon: Icons.photo_library,
                      label: tr.gallery,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        handleImageSelection(localOnTapGallery);
                      },
                    ),
                  if (localOnTapFile != null)
                    _buildImagePickerOption(
                      icon: Icons.upload_file,
                      label: tr.file,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        handleImageSelection(localOnTapFile);
                      },
                    ),
                ],
              ),
              12.height,
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(tr.cancel,
                    style: TextStyle(color: context.primary)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildImagePickerOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.black87),
        ),
        8.height,
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

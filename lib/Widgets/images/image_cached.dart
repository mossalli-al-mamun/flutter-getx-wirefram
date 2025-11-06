import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_logger.dart';
import '../app_loaders.dart';

class ImageCached extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final BoxShape shape;
  final String? placeholderAsset;
  final IconData? placeholderIcon;
  final double loaderSize;
  final bool showImagePath;
  final double? height;
  final double? width;
  final double? size;

  const ImageCached({
    super.key,
    this.imageUrl,
    this.fit = BoxFit.contain,
    this.shape = BoxShape.rectangle,
    this.placeholderAsset,
    this.placeholderIcon,
    this.loaderSize = 0.5,
    this.showImagePath = false,
    this.height = 15.0,
    this.width = 15.0,
    this.size,
  });

  bool get _isValidNetworkImage =>
      imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http');

  bool get _isLocalImage =>
      imageUrl != null && imageUrl!.isNotEmpty && !imageUrl!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isValidNetworkImage && !_isLocalImage) {
      return _buildPlaceholderImage();
    }

    if (_isLocalImage) {
      return _buildLocalImageWithPath();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      alignment: Alignment.center,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholderFadeInDuration: const Duration(milliseconds: 100),
      memCacheWidth: 180,
      // 2x the display size for high-res screens
      memCacheHeight: 180,
      placeholder: (context, url) => _buildPlaceholderWithLoader(),
      errorWidget: (context, url, error) => _buildErrorWidget(error),
      imageBuilder: (context, imageProvider) =>
          _buildImageContainer(imageProvider),
    );
  }

  Widget _buildImageContainer(ImageProvider imageProvider) {
    return Container(
      height: size ?? height,
      width: size ?? width,
      decoration: BoxDecoration(
        shape: shape,
        image: DecorationImage(
          alignment: Alignment.center,
          image: imageProvider,
          fit: fit,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    // Case 1 — Custom asset path provided
    if (placeholderAsset != null) {
      return Container(
        height: size ?? height,
        width: size ?? width,
        decoration: BoxDecoration(
          shape: shape,
          image: DecorationImage(
            alignment: Alignment.center,
            image: AssetImage(placeholderAsset!),
            fit: fit,
          ),
        ),
      );
    }

    // Case 2 — Icon provided instead of image
    if (placeholderIcon != null) {
      return Container(
        height: size ?? height,
        width: size ?? width,
        decoration: BoxDecoration(shape: shape, color: Colors.grey[200]),
        child: Icon(
          placeholderIcon,
          size: (size ?? height)! * 0.5,
          color: Colors.grey[500],
        ),
      );
    }

    // Case 3 — Default placeholder icon
    return Container(
      height: size ?? height,
      width: size ?? width,
      decoration: BoxDecoration(shape: shape, color: Colors.grey[200]),
      child: Icon(
        Icons.image_outlined,
        size: (size ?? height)! * 0.5,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildLocalImageWithPath() {
    return SizedBox(
      height: size ?? height,
      width: size ?? width,
      child: Image.file(
        File(imageUrl!),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderWithLoader() {
    return Container(
      height: size ?? height,
      width: size ?? width,
      decoration: BoxDecoration(shape: shape, color: Colors.grey[200]),
      child: Center(child: AppLoader(size: loaderSize)),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    appLogger('Image load error: $error for URL: $imageUrl');
    return Stack(
      children: [
        _buildPlaceholderImage(),
        const Center(child: Icon(Icons.error, color: Colors.red)),
      ],
    );
  }
}

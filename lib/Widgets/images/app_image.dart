import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

import '../app_loaders.dart';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;

  const AppImage({super.key,  this.imageUrl, this.fit=BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(
        imageUrl ??
            'https://dummyimage.com/150x150/cccccc/000000&text=Placeholder',
      ),
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: AppLoader(
            color: context.primary,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      fit: fit,
    );
  }
}

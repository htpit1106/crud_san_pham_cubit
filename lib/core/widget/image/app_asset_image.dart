import 'package:flutter/material.dart';

class AppAssetImage extends StatelessWidget {
  final String path;
  final Size? size;
  final BoxFit? fit;
  final Widget? placeholderImage;
  final Color? colorIcon;

  const AppAssetImage({
    super.key,
    this.path = "",
    this.size,
    this.fit,
    this.placeholderImage,
    this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size?.width,
      height: size?.height,
      errorBuilder: (context, url, error) {
        return _buildPlaceHolderImage();
      },
      fit: fit ?? BoxFit.cover,
      color: colorIcon,
    );
  }

  Widget _buildPlaceHolderImage() {
    return placeholderImage ??
        AppAssetImage(
          path: "AssetConstants.personAvtDefault",
          size: size ?? const Size(50, 50),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgImage extends StatelessWidget {
  const AppSvgImage(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.package,
    this.color,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final String? package;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      color: color,
      package: package,
    );
  }
}

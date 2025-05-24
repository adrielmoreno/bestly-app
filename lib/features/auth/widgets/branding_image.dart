import 'package:flutter/material.dart';

class BrandingImage extends StatelessWidget {
  const BrandingImage({super.key, this.height = 100});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/img/bestly.png'),
      height: height,
      semanticLabel: 'Bestly Logo',
    );
  }
}

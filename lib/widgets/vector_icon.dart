import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VectorIcon extends StatelessWidget {
  const VectorIcon({super.key, required this.icon, this.color, this.size});

  final String icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SvgPicture.asset(
      icon,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? theme.colorScheme.tertiary,
        BlendMode.srcIn,
      ),
    );
  }
}

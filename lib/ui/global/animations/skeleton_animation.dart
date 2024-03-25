import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonAnimation extends StatelessWidget {
  final double? width;
  final double? height;
  const SkeletonAnimation({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: const LinearGradient(
        colors: [
          Color(0xff1e1e1e),
          Color(0xff2a2a2a),
        ],
      ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
      ),
    );
  }
}

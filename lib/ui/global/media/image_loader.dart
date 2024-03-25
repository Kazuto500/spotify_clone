import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:spotify_clone/ui/global/animations/skeleton_animation.dart';

class ImageLoader extends StatelessWidget {
  final String imageUrl;
  const ImageLoader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(imageUrl),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          return const SkeletonAnimation();
        } else {
          return child;
        }
      },
    );
  }
}

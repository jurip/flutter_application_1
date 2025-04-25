import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import '../models/api_response.dart';

class ImageDetailScreen extends StatelessWidget {
  final ImageItem imageItem;

  const ImageDetailScreen({Key? key, required this.imageItem}) : super(key: key);

  Variant _getOptimalVariant(List<Variant> variants, double physicalWidth) {
    variants.sort((a, b) => a.width.compareTo(b.width));
    for (var variant in variants) {
      if (variant.width >= physicalWidth) {
        return variant;
      }
    }
    return variants.last;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final physicalWidth = screenWidth * devicePixelRatio;
    final optimalVariant = _getOptimalVariant(imageItem.variants, physicalWidth);

    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(optimalVariant.url),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/src/screens/image_detail_screen.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class ImageGridScreen extends StatefulWidget {
  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  final ApiService _apiService = ApiService();
  final List<ImageItem> _images = [];
  String? _continuationToken;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _continuationToken != null) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiService.fetchImages();
      setState(() {
        _images.addAll(response.result.items);
        _continuationToken = response.result.continuationToken;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  Future<void> _loadMoreData() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiService.fetchImages(continuationToken: _continuationToken);
      setState(() {
        _images.addAll(response.result.items);
        _continuationToken = response.result.continuationToken;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Variant _getOptimalVariant(List<Variant> variants, double containerWidth) {
    variants.sort((a, b) => a.width.compareTo(b.width));
    for (var variant in variants) {
      if (variant.width >= containerWidth) {
        return variant;
      }
    }
    return variants.last;
  }

  void _openImageDetail(ImageItem imageItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(imageItem: imageItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Images')),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: _images.length + (_continuationToken != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _images.length) {
            return Center(child: CircularProgressIndicator());
          }
          final imageItem = _images[index];
          return GestureDetector(
            onTap: () => _openImageDetail(imageItem),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final containerWidth = constraints.maxWidth;
                final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
                final physicalWidth = containerWidth * devicePixelRatio;
                final optimalVariant = _getOptimalVariant(imageItem.variants, physicalWidth);
                return CachedNetworkImage(
                  imageUrl: optimalVariant.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
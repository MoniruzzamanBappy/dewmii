import 'package:flutter/material.dart';

class ProductImageGalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ProductImageGalleryScreen({super.key, required this.images, this.initialIndex = 0});

  @override
  State<ProductImageGalleryScreen> createState() => _ProductImageGalleryScreenState();
}

class _ProductImageGalleryScreenState extends State<ProductImageGalleryScreen> {
  late final PageController _pageController;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.images.isEmpty ? 0 : widget.images.length - 1);
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images.where((url) => url.trim().isNotEmpty).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(images.isEmpty ? 'Gallery' : '${_index + 1} / ${images.length}'),
        centerTitle: true,
      ),
      body: images.isEmpty
          ? const Center(child: Icon(Icons.image_not_supported_rounded, size: 72, color: Colors.white54))
          : Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Center(
                        child: Hero(
                          tag: 'product-image-${images[index]}',
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded, size: 72, color: Colors.white54),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (images.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 22,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(images.length, (dotIndex) {
                            final selected = dotIndex == _index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: selected ? 22 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: selected ? Colors.white : Colors.white38,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

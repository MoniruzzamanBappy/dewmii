import 'package:flutter/material.dart';

class ProductImageGalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ProductImageGalleryScreen({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ProductImageGalleryScreen> createState() =>
      _ProductImageGalleryScreenState();
}

class _ProductImageGalleryScreenState extends State<ProductImageGalleryScreen> {
  late final PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${currentIndex + 1}/${widget.images.length}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(widget.images[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}

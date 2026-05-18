import 'package:dewmii/features/discovery/screens/subcategory_screen.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/category_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/category_card.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubcategoryScreen(category: category),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

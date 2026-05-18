import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/product_model.dart';
import '../services/discovery_api_service.dart';

class FilterSortScreen extends StatefulWidget {
  final String? query;
  final int? categoryId;

  const FilterSortScreen({super.key, this.query, this.categoryId});

  @override
  State<FilterSortScreen> createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  RangeValues priceRange = const RangeValues(0, 5000);
  double minRating = 0;
  String sortBy = 'default';

  bool isLoading = false;

  Future<void> applyFilter() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<ProductModel> result = await service.filterProducts(
        query: widget.query,
        categoryId: widget.categoryId,
        minPrice: priceRange.start,
        maxPrice: priceRange.end,
        minRating: minRating,
        sortBy: sortBy,
      );

      if (!mounted) return;

      Navigator.pop(context, result);
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

  void resetFilter() {
    setState(() {
      priceRange = const RangeValues(0, 5000);
      minRating = 0;
      sortBy = 'default';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter & Sort'),
        actions: [
          TextButton(onPressed: resetFilter, child: const Text('Reset')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          RangeSlider(
            min: 0,
            max: 5000,
            divisions: 50,
            values: priceRange,
            labels: RangeLabels(
              '৳${priceRange.start.round()}',
              '৳${priceRange.end.round()}',
            ),
            onChanged: (value) {
              setState(() {
                priceRange = value;
              });
            },
          ),
          Text('৳${priceRange.start.round()} - ৳${priceRange.end.round()}'),
          const SizedBox(height: 26),
          const Text(
            'Minimum Rating',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Slider(
            min: 0,
            max: 5,
            divisions: 5,
            value: minRating,
            label: '${minRating.round()} Star',
            onChanged: (value) {
              setState(() {
                minRating = value;
              });
            },
          ),
          Text('${minRating.round()} star and above'),
          const SizedBox(height: 26),
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: sortBy,
            items: const [
              DropdownMenuItem(value: 'default', child: Text('Default')),
              DropdownMenuItem(
                value: 'price_low_high',
                child: Text('Price: Low to High'),
              ),
              DropdownMenuItem(
                value: 'price_high_low',
                child: Text('Price: High to Low'),
              ),
              DropdownMenuItem(
                value: 'rating_high_low',
                child: Text('Rating: High to Low'),
              ),
              DropdownMenuItem(value: 'name_a_z', child: Text('Name: A to Z')),
            ],
            onChanged: (value) {
              setState(() {
                sortBy = value ?? 'default';
              });
            },
          ),
          const SizedBox(height: 34),
          ElevatedButton(
            onPressed: isLoading ? null : applyFilter,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Apply Filter'),
          ),
        ],
      ),
    );
  }
}

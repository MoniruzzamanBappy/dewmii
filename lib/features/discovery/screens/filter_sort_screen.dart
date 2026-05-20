import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
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
    setState(() => isLoading = true);

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
      if (mounted) setState(() => isLoading = false);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter & Sort'),
        actions: [
          TextButton(onPressed: resetFilter, child: const Text('Reset')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: [
          _FilterHero(query: widget.query),
          const SizedBox(height: 20),
          _FilterCard(
            title: 'Price Range',
            icon: Icons.payments_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  values: priceRange,
                  labels: RangeLabels(
                    '৳${priceRange.start.round()}',
                    '৳${priceRange.end.round()}',
                  ),
                  onChanged: (value) => setState(() => priceRange = value),
                ),
                Row(
                  children: [
                    _PricePill(label: '৳${priceRange.start.round()}'),
                    const Spacer(),
                    _PricePill(label: '৳${priceRange.end.round()}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _FilterCard(
            title: 'Minimum Rating',
            icon: Icons.star_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  min: 0,
                  max: 5,
                  divisions: 5,
                  value: minRating,
                  label: '${minRating.round()} Star',
                  onChanged: (value) => setState(() => minRating = value),
                ),
                Wrap(
                  spacing: 8,
                  children: List.generate(6, (index) {
                    final selected = minRating.round() == index;
                    return ChoiceChip(
                      selected: selected,
                      label: Text(index == 0 ? 'Any' : '$index★'),
                      onSelected: (_) =>
                          setState(() => minRating = index.toDouble()),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _FilterCard(
            title: 'Sort By',
            icon: Icons.sort_rounded,
            child: DropdownButtonFormField<String>(
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
                DropdownMenuItem(
                  value: 'name_a_z',
                  child: Text('Name: A to Z'),
                ),
              ],
              onChanged: (value) => setState(() => sortBy = value ?? 'default'),
            ),
          ),
          const SizedBox(height: 28),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: isLoading ? 0.08 : 0.22,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : applyFilter,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.3),
                    )
                  : const Icon(Icons.check_circle_rounded),
              label: Text(isLoading ? 'Applying...' : 'Apply Filter'),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterHero extends StatelessWidget {
  final String? query;

  const _FilterHero({this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? AppColors.darkHeroGradient
            : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(Icons.tune_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refine your results',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  query == null
                      ? 'Adjust price, rating, and sorting'
                      : 'Filtering "$query"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FilterCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.16 : 0.045,
            ),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  final String label;

  const _PricePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

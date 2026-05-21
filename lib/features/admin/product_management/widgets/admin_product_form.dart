import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AdminProductForm extends StatefulWidget {
  final String? initialName;
  final String? initialSku;
  final String? initialShortDescription;
  final String? initialDescription;
  final num? initialPrice;
  final num? initialDiscountPrice;
  final int? initialStock;
  final bool initialFeatured;
  final String initialStatus;
  final ValueChanged<Map<String, dynamic>> onSubmit;
  final bool isLoading;
  final String submitLabel;

  const AdminProductForm({
    super.key,
    this.initialName,
    this.initialSku,
    this.initialShortDescription,
    this.initialDescription,
    this.initialPrice,
    this.initialDiscountPrice,
    this.initialStock,
    this.initialFeatured = false,
    this.initialStatus = 'active',
    required this.onSubmit,
    required this.isLoading,
    required this.submitLabel,
  });

  @override
  State<AdminProductForm> createState() => _AdminProductFormState();
}

class _AdminProductFormState extends State<AdminProductForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController skuController;
  late final TextEditingController shortDescriptionController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController stockController;

  late bool isFeatured;
  late String status;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.initialName ?? '');
    skuController = TextEditingController(text: widget.initialSku ?? '');
    shortDescriptionController = TextEditingController(
      text: widget.initialShortDescription ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
    priceController = TextEditingController(
      text: widget.initialPrice == null ? '' : '${widget.initialPrice}',
    );
    discountPriceController = TextEditingController(
      text: widget.initialDiscountPrice == null
          ? ''
          : '${widget.initialDiscountPrice}',
    );
    stockController = TextEditingController(
      text: widget.initialStock == null ? '' : '${widget.initialStock}',
    );

    isFeatured = widget.initialFeatured;
    status = widget.initialStatus.isEmpty ? 'active' : widget.initialStatus;
  }

  @override
  void dispose() {
    nameController.dispose();
    skuController.dispose();
    shortDescriptionController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  String _slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();

    widget.onSubmit({
      'category_id': 1,
      'brand_id': 2,
      'name': name,
      'slug': _slugify(name),
      'sku': skuController.text.trim(),
      'short_description': shortDescriptionController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': num.tryParse(priceController.text.trim()) ?? 0,
      'discount_price': num.tryParse(discountPriceController.text.trim()) ?? 0,
      'stock': int.tryParse(stockController.text.trim()) ?? 0,
      'status': status,
      'is_featured': isFeatured,
    });
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        minLines: maxLines > 1 ? 2 : 1,
        maxLines: maxLines,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        textInputAction: maxLines > 1 ? TextInputAction.done : TextInputAction.next,
        validator: (value) {
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }

          if (keyboardType == TextInputType.number &&
              value != null &&
              value.trim().isNotEmpty &&
              num.tryParse(value.trim()) == null) {
            return 'Enter a valid number';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: formKey,
      child: Column(
        children: [
          _SectionCard(
            title: 'Basic Information',
            icon: Icons.edit_note_rounded,
            children: [
              _field(
                label: 'Product Name',
                controller: nameController,
                icon: Icons.shopping_bag_outlined,
              ),
              _field(
                label: 'SKU',
                controller: skuController,
                icon: Icons.qr_code_2_rounded,
              ),
              _field(
                label: 'Short Description',
                controller: shortDescriptionController,
                icon: Icons.short_text_rounded,
              ),
              _field(
                label: 'Description',
                controller: descriptionController,
                icon: Icons.notes_rounded,
                maxLines: 4,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Pricing & Inventory',
            icon: Icons.inventory_2_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: 'Price',
                      controller: priceController,
                      icon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      label: 'Sale Price',
                      controller: discountPriceController,
                      icon: Icons.local_offer_outlined,
                      keyboardType: TextInputType.number,
                      requiredField: false,
                    ),
                  ),
                ],
              ),
              _field(
                label: 'Stock',
                controller: stockController,
                icon: Icons.warehouse_outlined,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.toggle_on_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                ],
                onChanged: (value) => setState(() => status = value ?? 'active'),
              ),
              const SizedBox(height: 12),
              Material(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
                child: SwitchListTile.adaptive(
                  value: isFeatured,
                  title: const Text('Featured Product'),
                  subtitle: const Text('Show this item in featured sections'),
                  secondary: const Icon(Icons.star_border_rounded),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onChanged: (value) => setState(() => isFeatured = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: widget.isLoading ? null : submit,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.check_circle_rounded),
              label: Text(widget.isLoading ? 'Please wait...' : widget.submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                foregroundColor: AppColors.primary,
                child: Icon(icon),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

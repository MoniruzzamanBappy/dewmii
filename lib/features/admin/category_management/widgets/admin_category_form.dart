import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AdminCategoryForm extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final String? initialImageUrl;
  final String initialStatus;
  final int initialSortOrder;
  final bool isLoading;
  final String submitLabel;
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const AdminCategoryForm({
    super.key,
    this.initialName,
    this.initialDescription,
    this.initialImageUrl,
    this.initialStatus = 'active',
    this.initialSortOrder = 1,
    required this.isLoading,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  State<AdminCategoryForm> createState() => _AdminCategoryFormState();
}

class _AdminCategoryFormState extends State<AdminCategoryForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageController;
  late final TextEditingController sortOrderController;

  late String status;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.initialName ?? '');
    descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
    imageController = TextEditingController(text: widget.initialImageUrl ?? '');
    sortOrderController = TextEditingController(
      text: '${widget.initialSortOrder}',
    );
    status = widget.initialStatus.isEmpty ? 'active' : widget.initialStatus;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    sortOrderController.dispose();
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
      'parent_id': null,
      'name': name,
      'slug': _slugify(name),
      'description': descriptionController.text.trim(),
      'image_url': imageController.text.trim(),
      'status': status,
      'sort_order': int.tryParse(sortOrderController.text.trim()) ?? 1,
    });
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    bool required = true,
  }) {
    final isMultiline = maxLines > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        minLines: isMultiline ? 3 : 1,
        maxLines: maxLines,
        keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
        textInputAction: isMultiline ? TextInputAction.newline : TextInputAction.next,
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.category_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Category Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _field(
                  label: 'Category Name',
                  controller: nameController,
                  icon: Icons.drive_file_rename_outline_rounded,
                  hintText: 'Example: Beauty',
                ),
                _field(
                  label: 'Description',
                  controller: descriptionController,
                  icon: Icons.description_outlined,
                  maxLines: 5,
                  hintText: 'Write a short category description',
                ),
                _field(
                  label: 'Image URL',
                  controller: imageController,
                  icon: Icons.image_outlined,
                  hintText: 'https://example.com/category.png',
                  required: false,
                ),
                _field(
                  label: 'Sort Order',
                  controller: sortOrderController,
                  icon: Icons.sort_rounded,
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
                  ],
                  onChanged: widget.isLoading
                      ? null
                      : (value) {
                          setState(() => status = value ?? 'active');
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
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

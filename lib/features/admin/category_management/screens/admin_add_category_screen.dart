import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../services/admin_category_api_service.dart';
import '../widgets/admin_category_form.dart';

class AdminAddCategoryScreen extends StatefulWidget {
  const AdminAddCategoryScreen({super.key});

  @override
  State<AdminAddCategoryScreen> createState() => _AdminAddCategoryScreenState();
}

class _AdminAddCategoryScreenState extends State<AdminAddCategoryScreen> {
  final AdminCategoryApiService service = AdminCategoryApiService();

  bool isLoading = false;

  Future<void> createCategory(Map<String, dynamic> body) async {
    setState(() => isLoading = true);

    try {
      final response = await service.createCategory(body: body);
      final category = service.parseCategory(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Category created successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, category);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const _FormHero(
            title: 'Create a new category',
            subtitle: 'Organize your catalog with a clear name, image, status and display order.',
          ),
          const SizedBox(height: 18),
          AdminCategoryForm(
            isLoading: isLoading,
            submitLabel: 'Create Category',
            onSubmit: createCategory,
          ),
        ],
      ),
    );
  }
}

class _FormHero extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FormHero({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.add_business_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
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

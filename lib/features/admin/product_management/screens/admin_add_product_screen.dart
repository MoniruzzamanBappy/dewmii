import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../services/admin_product_api_service.dart';
import '../widgets/admin_product_form.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({super.key});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final AdminProductApiService service = AdminProductApiService();

  bool isLoading = false;

  Future<void> createProduct(Map<String, dynamic> body) async {
    setState(() => isLoading = true);

    try {
      final response = await service.createProductDemo(body: body);
      final createdProduct = service.parseProduct(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Product created successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, createdProduct);
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
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const _FormHero(),
          const SizedBox(height: 18),
          AdminProductForm(
            isLoading: isLoading,
            submitLabel: 'Create Product',
            onSubmit: createProduct,
          ),
        ],
      ),
    );
  }
}

class _FormHero extends StatelessWidget {
  const _FormHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            foregroundColor: Colors.white,
            child: Icon(Icons.add_business_rounded),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Create a new product with pricing, stock and visibility settings.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_product_model.dart';
import '../services/admin_product_api_service.dart';

class AdminProductStockScreen extends StatefulWidget {
  final AdminProductModel product;

  const AdminProductStockScreen({super.key, required this.product});

  @override
  State<AdminProductStockScreen> createState() =>
      _AdminProductStockScreenState();
}

class _AdminProductStockScreenState extends State<AdminProductStockScreen> {
  final AdminProductApiService service = AdminProductApiService();

  late final TextEditingController stockController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stockController = TextEditingController(text: '${widget.product.stock}');
  }

  @override
  void dispose() {
    stockController.dispose();
    super.dispose();
  }

  Future<void> updateStock() async {
    final stock = int.tryParse(stockController.text.trim());

    if (stock == null || stock < 0) {
      AppToast.show(
        context,
        message: 'Enter a valid stock quantity',
        type: ToastType.warning,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await service.updateStockDemo(
        productId: widget.product.id,
        stock: stock,
      );

      if (!mounted) return;

      final updatedStock = result?.stock ?? stock;
      final updatedStockStatus = result?.stockStatus ??
          (updatedStock <= 0 ? 'out_of_stock' : updatedStock <= 10 ? 'low_stock' : 'in_stock');

      AppToast.show(
        context,
        message: 'Product stock updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(
        context,
        widget.product.copyWith(
          stock: updatedStock,
          stockStatus: updatedStockStatus,
        ),
      );
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

  void _changeStock(int delta) {
    final current = int.tryParse(stockController.text.trim()) ?? 0;
    final next = (current + delta).clamp(0, 999999);
    stockController.text = '$next';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stock')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.inventory_2_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SKU: ${widget.product.sku}'),
                const SizedBox(height: 6),
                Text('Current stock: ${widget.product.stock}'),
                const SizedBox(height: 18),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    prefixIcon: Icon(Icons.warehouse_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _changeStock(-1),
                        icon: const Icon(Icons.remove_rounded),
                        label: const Text('Decrease'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _changeStock(1),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Increase'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: isLoading ? null : updateStock,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(isLoading ? 'Updating...' : 'Update Stock'),
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

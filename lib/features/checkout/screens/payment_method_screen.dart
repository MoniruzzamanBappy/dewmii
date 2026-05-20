import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/payment_method_model.dart';
import '../services/checkout_api_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  final PaymentMethodModel? selectedMethod;

  const PaymentMethodScreen({super.key, this.selectedMethod});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final CheckoutApiService service = CheckoutApiService();

  bool isLoading = true;
  List<PaymentMethodModel> methods = [];
  PaymentMethodModel? selectedMethod;

  @override
  void initState() {
    super.initState();
    fetchMethods();
  }

  Future<void> fetchMethods() async {
    try {
      final result = await service.getPaymentMethods();
      if (!mounted) return;
      setState(() {
        methods = result.where((item) => item.isActive).toList();
        selectedMethod = widget.selectedMethod ?? (methods.isNotEmpty ? methods.first : null);
      });
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: selectedMethod == null ? null : () => Navigator.pop(context, selectedMethod),
          child: const Text('Select Payment Method'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : methods.isEmpty
              ? const Center(child: Text('No payment method found'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                  children: methods.map((method) {
                    final selected = selectedMethod?.id == method.id;
                    return _PaymentTile(
                      method: method,
                      selected: selected,
                      onTap: () => setState(() => selectedMethod = method),
                    );
                  }).toList(),
                ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentMethodModel method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = selected ? AppColors.primary : (dark ? AppColors.darkBorder : AppColors.lightBorder);
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: selected ? 1.6 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: method.logoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(method.logoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.payment_rounded, color: AppColors.primary)),
                      )
                    : const Icon(Icons.payment_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Text(
                      method.description.isEmpty
                          ? (method.isOnline ? 'Online payment' : 'Pay when you receive')
                          : method.description,
                      style: TextStyle(color: secondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              Radio<PaymentMethodModel>(
                value: method,
                groupValue: selected ? method : null,
                onChanged: (_) => onTap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

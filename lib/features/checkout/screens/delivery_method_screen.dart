import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/shipping_method_model.dart';
import '../services/checkout_api_service.dart';

class DeliveryMethodScreen extends StatefulWidget {
  final ShippingMethodModel? selectedMethod;

  const DeliveryMethodScreen({super.key, this.selectedMethod});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  final CheckoutApiService service = CheckoutApiService();

  bool isLoading = true;
  List<ShippingMethodModel> methods = [];
  ShippingMethodModel? selectedMethod;

  @override
  void initState() {
    super.initState();
    fetchMethods();
  }

  Future<void> fetchMethods() async {
    try {
      final result = await service.getShippingMethods();
      if (!mounted) return;
      setState(() {
        methods = result;
        selectedMethod = widget.selectedMethod ?? (result.isNotEmpty ? result.first : null);
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
    return _SelectScaffold<ShippingMethodModel>(
      title: 'Delivery Method',
      buttonText: 'Select Delivery Method',
      isLoading: isLoading,
      selectedValue: selectedMethod,
      onSelect: (value) => setState(() => selectedMethod = value),
      onConfirm: selectedMethod == null ? null : () => Navigator.pop(context, selectedMethod),
      children: methods.map((method) {
        return _OptionTile<ShippingMethodModel>(
          value: method,
          groupValue: selectedMethod,
          enabled: method.isAvailable,
          title: method.name,
          subtitle: [
            method.description,
            method.estimatedDays,
            if (method.city.isNotEmpty) method.city,
          ].where((item) => item.trim().isNotEmpty).join('\n'),
          trailing: method.formattedCharge,
          icon: Icons.local_shipping_rounded,
          onChanged: method.isAvailable ? (value) => setState(() => selectedMethod = value) : null,
        );
      }).toList(),
    );
  }
}

class _SelectScaffold<T> extends StatelessWidget {
  final String title;
  final String buttonText;
  final bool isLoading;
  final T? selectedValue;
  final List<Widget> children;
  final ValueChanged<T?> onSelect;
  final VoidCallback? onConfirm;

  const _SelectScaffold({
    required this.title,
    required this.buttonText,
    required this.isLoading,
    required this.selectedValue,
    required this.children,
    required this.onSelect,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: onConfirm,
          child: Text(buttonText),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : children.isEmpty
              ? const Center(child: Text('No option found'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                  children: children,
                ),
    );
  }
}

class _OptionTile<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final bool enabled;
  final ValueChanged<T?>? onChanged;

  const _OptionTile({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = selected ? AppColors.primary : (dark ? AppColors.darkBorder : AppColors.lightBorder);
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: enabled ? surface : surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: selected ? 1.6 : 1),
      ),
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(value) : null,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Text(subtitle.isEmpty ? 'No details available' : subtitle, style: TextStyle(color: secondary, height: 1.35)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(trailing, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
                  Radio<T>(value: value, groupValue: groupValue, onChanged: enabled ? onChanged : null),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

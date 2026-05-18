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

  Future<void> fetchMethods() async {
    try {
      final result = await service.getShippingMethods();

      if (!mounted) return;

      setState(() {
        methods = result;
        selectedMethod =
            widget.selectedMethod ?? (result.isNotEmpty ? result.first : null);
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
    fetchMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Method')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedMethod == null
                ? null
                : () {
                    Navigator.pop(context, selectedMethod);
                  },
            child: const Text('Select Delivery Method'),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: methods.map((method) {
                final isSelected = selectedMethod?.id == method.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightBorder,
                      width: isSelected ? 1.6 : 1,
                    ),
                  ),
                  child: RadioListTile<ShippingMethodModel>(
                    value: method,
                    groupValue: selectedMethod,
                    onChanged: method.isAvailable
                        ? (value) {
                            setState(() {
                              selectedMethod = value;
                            });
                          }
                        : null,
                    title: Text(
                      method.name,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      '${method.description}\n${method.estimatedDays}',
                    ),
                    secondary: Text(
                      '৳${method.charge}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

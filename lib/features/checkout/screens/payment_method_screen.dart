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

  Future<void> fetchMethods() async {
    try {
      final result = await service.getPaymentMethods();

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
      appBar: AppBar(title: const Text('Payment Method')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedMethod == null
                ? null
                : () {
                    Navigator.pop(context, selectedMethod);
                  },
            child: const Text('Select Payment Method'),
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
                  child: RadioListTile<PaymentMethodModel>(
                    value: method,
                    groupValue: selectedMethod,
                    onChanged: method.isActive
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
                      '${method.description}\n${method.isOnline ? 'Online Payment' : 'Offline Payment'}',
                    ),
                    secondary: method.logoUrl.isEmpty
                        ? const Icon(Icons.payment_rounded)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              method.logoUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

import 'package:dewmii/features/checkout/screens/delivery_method_screen.dart';
import 'package:dewmii/features/checkout/screens/order_review_screen.dart';
import 'package:dewmii/features/checkout/screens/payment_method_screen.dart';
import 'package:dewmii/features/checkout/screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/address_model.dart';
import '../models/checkout_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_method_model.dart';
import '../services/checkout_api_service.dart';
import '../widgets/checkout_step_card.dart';
import '../widgets/order_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutApiService service = CheckoutApiService();

  bool isLoading = true;
  bool isValidating = false;

  CheckoutModel? checkout;
  AddressModel? selectedAddress;
  ShippingMethodModel? selectedShippingMethod;
  PaymentMethodModel? selectedPaymentMethod;

  Future<void> fetchCheckout() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getCheckoutData();

      if (!mounted) return;

      setState(() {
        checkout = result;
        selectedAddress = result?.defaultAddress;
        selectedShippingMethod = result?.shippingMethods.isNotEmpty == true
            ? result!.shippingMethods.first
            : null;
        selectedPaymentMethod = result?.paymentMethods.isNotEmpty == true
            ? result!.paymentMethods.first
            : null;
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

  Future<void> validateAndContinue() async {
    if (selectedAddress == null ||
        selectedShippingMethod == null ||
        selectedPaymentMethod == null) {
      AppToast.show(
        context,
        message: 'Please select address, delivery and payment method',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isValidating = true;
    });

    try {
      final response = await service.validateCheckoutDemo();

      if (!mounted) return;

      if (!service.isCheckoutValid(response)) {
        AppToast.show(
          context,
          message: 'Checkout validation failed',
          type: ToastType.error,
        );
        return;
      }

      AppToast.show(
        context,
        message: response['message'] ?? 'Checkout validated successfully',
        type: ToastType.success,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderReviewScreen(
            address: selectedAddress!,
            shippingMethod: selectedShippingMethod!,
            paymentMethod: selectedPaymentMethod!,
          ),
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
      if (mounted) {
        setState(() {
          isValidating = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCheckout();
  }

  @override
  Widget build(BuildContext context) {
    final data = checkout;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      bottomNavigationBar: data == null
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.lightSurface,
                  border: Border(top: BorderSide(color: AppColors.lightBorder)),
                ),
                child: ElevatedButton(
                  onPressed: isValidating ? null : validateAndContinue,
                  child: isValidating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Review Order'),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text('No checkout data found'))
          : RefreshIndicator(
              onRefresh: fetchCheckout,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CheckoutStepCard(
                    title: 'Shipping Address',
                    subtitle:
                        selectedAddress?.fullAddress ??
                        'Select delivery address',
                    icon: Icons.location_on_rounded,
                    onTap: () async {
                      final address = await Navigator.push<AddressModel>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShippingAddressScreen(
                            addresses: data.addresses,
                            selectedAddress: selectedAddress,
                          ),
                        ),
                      );

                      if (address != null) {
                        setState(() {
                          selectedAddress = address;
                        });
                      }
                    },
                  ),
                  CheckoutStepCard(
                    title: 'Delivery Method',
                    subtitle: selectedShippingMethod == null
                        ? 'Select delivery option'
                        : '${selectedShippingMethod!.name} • ৳${selectedShippingMethod!.charge}',
                    icon: Icons.local_shipping_rounded,
                    onTap: () async {
                      final method = await Navigator.push<ShippingMethodModel>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeliveryMethodScreen(
                            selectedMethod: selectedShippingMethod,
                          ),
                        ),
                      );

                      if (method != null) {
                        setState(() {
                          selectedShippingMethod = method;
                        });
                      }
                    },
                  ),
                  CheckoutStepCard(
                    title: 'Payment Method',
                    subtitle: selectedPaymentMethod?.name ?? 'Select payment',
                    icon: Icons.payment_rounded,
                    onTap: () async {
                      final method = await Navigator.push<PaymentMethodModel>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentMethodScreen(
                            selectedMethod: selectedPaymentMethod,
                          ),
                        ),
                      );

                      if (method != null) {
                        setState(() {
                          selectedPaymentMethod = method;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...data.cartItems.map((item) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.network(
                          item.thumbnail,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.name),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text(
                          '৳${item.subtotal}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  OrderSummaryCard(summary: data.summary),
                  const SizedBox(height: 90),
                ],
              ),
            ),
    );
  }
}

import '../../cart/models/cart_coupon_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../cart/models/cart_summary_model.dart';
import 'address_model.dart';
import 'payment_method_model.dart';
import 'shipping_method_model.dart';

class CheckoutModel {
  final List<CartItemModel> cartItems;
  final AddressModel? defaultAddress;
  final List<AddressModel> addresses;
  final List<ShippingMethodModel> shippingMethods;
  final List<PaymentMethodModel> paymentMethods;
  final CartCouponModel? coupon;
  final CartSummaryModel summary;

  CheckoutModel({
    required this.cartItems,
    this.defaultAddress,
    required this.addresses,
    required this.shippingMethods,
    required this.paymentMethods,
    this.coupon,
    required this.summary,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final cart = json['cart'];
    final cartMap = cart is Map<String, dynamic> ? cart : <String, dynamic>{};
    final itemsJson = json['items'] ?? cartMap['items'];
    final addressesJson = json['addresses'];
    final shippingJson = json['shipping_methods'] ?? json['shippingMethods'];
    final paymentJson = json['payment_methods'] ?? json['paymentMethods'];
    final couponJson = json['coupon'] ?? cartMap['coupon'];
    final summaryJson = json['summary'] ?? cartMap['summary'];

    return CheckoutModel(
      cartItems: _list(itemsJson, CartItemModel.fromJson),
      defaultAddress: json['default_address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['default_address'] as Map<String, dynamic>)
          : json['defaultAddress'] is Map<String, dynamic>
              ? AddressModel.fromJson(json['defaultAddress'] as Map<String, dynamic>)
              : null,
      addresses: _list(addressesJson, AddressModel.fromJson),
      shippingMethods: _list(shippingJson, ShippingMethodModel.fromJson),
      paymentMethods: _list(paymentJson, PaymentMethodModel.fromJson),
      coupon: couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null,
      summary: summaryJson is Map<String, dynamic>
          ? CartSummaryModel.fromJson(summaryJson)
          : CartSummaryModel.empty(),
    );
  }

  static List<T> _list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map((item) => parser(Map<String, dynamic>.from(item)))
        .toList();
  }
}

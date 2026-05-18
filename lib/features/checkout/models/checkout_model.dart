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
    final cartItems = cart is Map<String, dynamic> ? cart['items'] : null;
    final addressesJson = json['addresses'];
    final shippingJson = json['shipping_methods'];
    final paymentJson = json['payment_methods'];
    final couponJson = json['coupon'];

    return CheckoutModel(
      cartItems: cartItems is List
          ? cartItems
                .map(
                  (item) =>
                      CartItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      defaultAddress: json['default_address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['default_address'])
          : null,
      addresses: addressesJson is List
          ? addressesJson
                .map(
                  (item) => AddressModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      shippingMethods: shippingJson is List
          ? shippingJson
                .map(
                  (item) => ShippingMethodModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      paymentMethods: paymentJson is List
          ? paymentJson
                .map(
                  (item) =>
                      PaymentMethodModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      coupon: couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null,
      summary: CartSummaryModel.fromJson(
        json['summary'] ?? <String, dynamic>{},
      ),
    );
  }
}

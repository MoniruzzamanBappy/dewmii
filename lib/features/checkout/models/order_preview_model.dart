import '../../cart/models/cart_coupon_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../cart/models/cart_summary_model.dart';
import 'address_model.dart';
import 'shipping_method_model.dart';

class OrderPreviewModel {
  final List<CartItemModel> items;
  final AddressModel address;
  final ShippingMethodModel shippingMethod;
  final CartCouponModel? coupon;
  final CartSummaryModel summary;

  OrderPreviewModel({
    required this.items,
    required this.address,
    required this.shippingMethod,
    this.coupon,
    required this.summary,
  });

  factory OrderPreviewModel.fromJson(Map<String, dynamic> json) {
    final couponJson = json['coupon'];

    return OrderPreviewModel(
      items: _list(json['items'], CartItemModel.fromJson),
      address: json['address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : AddressModel.fromJson(const <String, dynamic>{}),
      shippingMethod: json['shipping_method'] is Map<String, dynamic>
          ? ShippingMethodModel.fromJson(json['shipping_method'] as Map<String, dynamic>)
          : ShippingMethodModel.fromJson(const <String, dynamic>{}),
      coupon: couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null,
      summary: json['summary'] is Map<String, dynamic>
          ? CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>)
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

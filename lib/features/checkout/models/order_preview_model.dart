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
    final itemsJson = json['items'];
    final couponJson = json['coupon'];

    return OrderPreviewModel(
      items: itemsJson is List
          ? itemsJson
                .map(
                  (item) =>
                      CartItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      address: AddressModel.fromJson(json['address'] ?? <String, dynamic>{}),
      shippingMethod: ShippingMethodModel.fromJson(
        json['shipping_method'] ?? <String, dynamic>{},
      ),
      coupon: couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null,
      summary: CartSummaryModel.fromJson(
        json['summary'] ?? <String, dynamic>{},
      ),
    );
  }
}

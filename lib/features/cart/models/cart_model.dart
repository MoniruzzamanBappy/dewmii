import 'cart_coupon_model.dart';
import 'cart_item_model.dart';
import 'cart_summary_model.dart';

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;
  final CartCouponModel? coupon;
  final CartSummaryModel summary;
  final DateTime? updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    this.coupon,
    required this.summary,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final couponJson = json['coupon'];

    return CartModel(
      id: json['id'] ?? json['cart_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      items: itemsJson is List
          ? itemsJson
                .map(
                  (item) =>
                      CartItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      coupon: couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null,
      summary: CartSummaryModel.fromJson(
        json['summary'] ?? <String, dynamic>{},
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  CartModel copyWith({
    List<CartItemModel>? items,
    CartCouponModel? coupon,
    bool clearCoupon = false,
    CartSummaryModel? summary,
  }) {
    return CartModel(
      id: id,
      userId: userId,
      items: items ?? this.items,
      coupon: clearCoupon ? null : coupon ?? this.coupon,
      summary: summary ?? this.summary,
      updatedAt: updatedAt,
    );
  }

  factory CartModel.empty() {
    return CartModel(
      id: 0,
      userId: 0,
      items: [],
      coupon: null,
      summary: CartSummaryModel.empty(),
      updatedAt: null,
    );
  }
}

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

  const CartModel({
    required this.id,
    required this.userId,
    required this.items,
    this.coupon,
    required this.summary,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] ?? json['cart_items'] ?? json['cartItems'];
    final couponJson = json['coupon'];
    final summaryJson = json['summary'];

    final items = itemsJson is List
        ? itemsJson
              .whereType<Map>()
              .map(
                (item) =>
                    CartItemModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <CartItemModel>[];

    return CartModel(
      id: _asInt(json['id'] ?? json['cart_id'] ?? json['cartId']),
      userId: _asInt(json['user_id'] ?? json['userId']),
      items: items,
      coupon: couponJson is Map
          ? CartCouponModel.fromJson(Map<String, dynamic>.from(couponJson))
          : null,
      summary: summaryJson is Map
          ? CartSummaryModel.fromJson(Map<String, dynamic>.from(summaryJson))
          : _summaryFromItems(items),
      updatedAt: _asDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  CartModel copyWith({
    List<CartItemModel>? items,
    CartCouponModel? coupon,
    bool clearCoupon = false,
    CartSummaryModel? summary,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id,
      userId: userId,
      items: items ?? this.items,
      coupon: clearCoupon ? null : coupon ?? this.coupon,
      summary: summary ?? this.summary,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CartModel.empty() {
    return CartModel(
      id: 0,
      userId: 0,
      items: const [],
      coupon: null,
      summary: CartSummaryModel.empty(),
      updatedAt: null,
    );
  }

  static CartSummaryModel _summaryFromItems(List<CartItemModel> items) {
    final subtotal = items.fold<num>(
      0,
      (sum, item) => sum + item.effectiveSubtotal,
    );
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    return CartSummaryModel.empty().copyWith(
      subtotal: subtotal,
      total: subtotal,
      totalItems: totalItems,
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

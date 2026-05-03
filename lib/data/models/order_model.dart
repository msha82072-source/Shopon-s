import 'product_model.dart';

class OrderModel {
  final String id;
  final String? userId;
  final String vendorId;
  final String status;
  final String paymentMethod;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    this.userId,
    required this.vendorId,
    required this.status,
    required this.paymentMethod,
    required this.totalAmount,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      vendorId: json['vendor_id'],
      status: json['status'],
      paymentMethod: json['payment_method'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((i) => OrderItemModel.fromJson(i))
              .toList()
          : [],
    );
  }
}

class OrderItemModel {
  final String id;
  final String? productId;
  final String? variantId;
  final int quantity;
  final double priceAtPurchase;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    this.productId,
    this.variantId,
    required this.quantity,
    required this.priceAtPurchase,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      priceAtPurchase: (json['price_at_purchase'] as num).toDouble(),
      product: json['products'] != null ? ProductModel.fromJson(json['products']) : null,
    );
  }
}

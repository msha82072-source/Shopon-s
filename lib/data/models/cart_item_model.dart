import '../../data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final ProductVariant? variant;
  int quantity;

  CartItemModel({
    required this.product,
    this.variant,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'variant_id': variant?.id,
      'quantity': quantity,
    };
  }
}

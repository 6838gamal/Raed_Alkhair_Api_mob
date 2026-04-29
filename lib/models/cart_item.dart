import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get pvSubtotal => product.pvValue * quantity.toDouble();

  double get memberSubtotal {
    final p = double.tryParse(product.priceMember) ?? 0;
    return p * quantity;
  }

  double get nonMemberSubtotal {
    final p = double.tryParse(product.priceNonMember) ?? 0;
    return p * quantity;
  }
}

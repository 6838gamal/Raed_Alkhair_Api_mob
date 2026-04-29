class Product {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final String priceMember;
  final String priceNonMember;
  final int pvValue;
  final String? imagePath;
  final bool isAvailable;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.priceMember,
    required this.priceNonMember,
    required this.pvValue,
    this.imagePath,
    required this.isAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        categoryId: json['category_id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        priceMember: (json['price_member'] ?? '').toString(),
        priceNonMember: (json['price_non_member'] ?? '').toString(),
        pvValue: (json['pv_value'] as num?)?.toInt() ?? 0,
        imagePath: json['image_path'] as String?,
        isAvailable: json['is_available'] as bool? ?? true,
      );
}

class ProductModel {
  final String? productId;
  final String? productName;
  final String? price;
  final String? oldPrice;
  final String? sale;
  final String? description;
  final String? imageUrl;
  final String? categoryId;
  final DateTime? createdAt;

  ProductModel({
    this.productId,
    this.productName,
    this.price,
    this.oldPrice,
    this.sale,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      price: json['price'] as String?,
      oldPrice: json['old_price'] as String?,
      sale: json['sale'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'old_price': oldPrice,
      'sale': sale,
      'description': description,
      'image_url': imageUrl,
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

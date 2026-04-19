class ProductEntity {
  final int? id;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final String? code;
  final double? price;
  final int? stock;
  final int? categoryId;
  final String? description;
  final String? image;
  ProductEntity({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.code,
    this.price,
    this.stock,
    this.description,
    this.image,
    this.categoryId,
  });
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'name': name,
      'code': code,
      'price': price,
      'stock': stock,
      'description': description,
      'image': image,
      'category_id': categoryId,
    };
  }

  // fromJson
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as int?,
      status: json['status'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      name: json['name'] as String?,
      code: json['code'] as String?,
      price: json["price"] != null ? (json['price'] as num).toDouble() : null,
      stock: json['stock'] as int?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      categoryId: json['category_id'] as int?,
    );
  }
}

import 'package:login_demo/data/model/entities/category_entity.dart';

class ProductEntity {
  final int? id;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final String? code;
  final double? price;
  final int? stock;
  final CategoryEntity? category;
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
    this.category
  });
  // copywith
  ProductEntity copyWith({
    int? id,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? code,
    double? price,
    int? stock,
    String? description,
    String? image,
    CategoryEntity? category,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      code: code ?? this.code,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }

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
      'category': category?.toJson(),
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
      category: json['category'] != null ? CategoryEntity.fromJson(json['category']) : null,
    );
  }
}

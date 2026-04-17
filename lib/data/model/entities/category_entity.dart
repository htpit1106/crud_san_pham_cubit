class CategoryEntity {
  final int? id;
  final int? status;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryEntity({
    this.id,
    this.status,
    this.name,
    this.createdAt,
    this.updatedAt,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // fromJson
  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'] as int?,
      status: json['status'] as int?,
      name: json['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

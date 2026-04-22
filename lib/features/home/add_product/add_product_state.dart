import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/enums/load_status.dart';

class AddProductState extends Equatable {
  final LoadStatus addProductStatus;
  final CategoryEntity? selectedCategory;
  final int? selectedStatus;
  final ProductEntity? productInfo;
  const AddProductState({
    this.addProductStatus = LoadStatus.initial,
    this.selectedCategory,
    this.selectedStatus,
    this.productInfo,
  });
  // copywith
  AddProductState copyWith({
    LoadStatus? addProductStatus,
    CategoryEntity? selectedCategory,
    int? selectedStatus,
    ProductEntity? productInfo,
  }) {
    return AddProductState(
      addProductStatus: addProductStatus ?? this.addProductStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      productInfo: productInfo ?? this.productInfo,
    );
  }

  @override
  List<Object?> get props => [
    addProductStatus,
    selectedCategory,
    selectedStatus,
    productInfo,
  ];
}

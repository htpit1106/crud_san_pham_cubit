import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/enums/load_status.dart';

class AddProductState extends Equatable {
  final LoadStatus addProductStatus;
  final int? selectedCategoryId;
  final int? selectedStatus;
  const AddProductState({
    this.addProductStatus = LoadStatus.initial,
    this.selectedCategoryId,
    this.selectedStatus = 1,
  });
  // copywith
  AddProductState copyWith({
    LoadStatus? addProductStatus,
    int? selectedCategoryId,
    int? selectedStatus,
  }) {
    return AddProductState(
      addProductStatus: addProductStatus ?? this.addProductStatus,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [
    addProductStatus,
    selectedCategoryId,
    selectedStatus,
  ];
}

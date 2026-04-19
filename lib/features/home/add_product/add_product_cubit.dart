import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/repositories/product_repository.dart';
import 'package:login_demo/features/home/add_product/add_product_navigator.dart';
import 'package:login_demo/features/home/add_product/add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  // ton kho =
  final TextEditingController stockController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController descriptionController = TextEditingController();

  final ProductRepository producRepository;
  final AddProductNavigator navigator;
  AddProductCubit({required this.producRepository, required this.navigator})
    : super(AddProductState());

  Future<bool> onSubmit() async {
    if (state.addProductStatus == LoadStatus.loading) return false;

    final newProduct = ProductEntity(
      name: nameController.text,
      code: codeController.text,
      price: double.tryParse(priceController.text) ?? 0,
      stock: int.tryParse(stockController.text) ?? 0,
      description: descriptionController.text,
      status: state.selectedStatus,
      categoryId: state.selectedCategoryId,
    );

    emit(state.copyWith(addProductStatus: LoadStatus.loading));
    final result = await producRepository.createProduct(newProduct);
    return result.fold(
      (failure) {
        emit(state.copyWith(addProductStatus: LoadStatus.failure));
        navigator.flushbarNavigator.showError(message: failure.message);
        return false;
      },
      (_) async {
        emit(state.copyWith(addProductStatus: LoadStatus.success));
        return true;
      },
    );
  }

  void onChangeStatus(int? value) {
    emit(state.copyWith(selectedStatus: value));
  }

  void onChangeCategory(int? value) {
    emit(state.copyWith(selectedCategoryId: value));
  }
}

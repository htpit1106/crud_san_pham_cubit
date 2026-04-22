import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_state.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState(onBiometric: false));

  void setOnBiometric(bool onBiometric) {
    emit(state.copyWith(onBiometric: onBiometric));
  }

  void setCategories(List<CategoryEntity> categories) {
    emit(state.copyWith(categories: categories));
  }
}

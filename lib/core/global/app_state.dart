import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';

class AppState extends Equatable {
  final bool onBiometric;
  final List<CategoryEntity>? categories;
  const AppState({required this.onBiometric, this.categories});

  AppState copyWith({bool? onBiometric, List<CategoryEntity>? categories}) {
    return AppState(
      onBiometric: onBiometric ?? this.onBiometric,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [onBiometric];
}

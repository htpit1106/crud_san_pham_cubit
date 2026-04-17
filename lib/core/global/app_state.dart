import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final bool onBiometric;
  const AppState({required this.onBiometric});

  AppState copyWith({bool? onBiometric}) {
    return AppState(onBiometric: onBiometric ?? this.onBiometric);
  }

  @override
  List<Object?> get props => [onBiometric];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState(onBiometric: false));

  void setOnBiometric(bool onBiometric) {
    emit(state.copyWith(onBiometric: onBiometric));
  }
}

import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/model/enums/login_status.dart';

class LoginState extends Equatable {
  final LoadStatus loadLoginStatus;
  final LoginStatus loginStatus;
  final bool isSubmit;
  final bool isLoginCountLimit;

  const LoginState({
    this.loadLoginStatus = LoadStatus.initial,
    this.loginStatus = LoginStatus.initial,
    this.isSubmit = false,
    this.isLoginCountLimit = false,
  });

  LoginState copyWith({
    LoadStatus? loadLoginStatus,
    LoginStatus? loginStatus,
    bool? isSubmit,
    bool? isLoginCountLimit,
  }) {
    return LoginState(
      loadLoginStatus: loadLoginStatus ?? this.loadLoginStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      isSubmit: isSubmit ?? this.isSubmit,
      isLoginCountLimit: isLoginCountLimit ?? this.isLoginCountLimit,
    );
  }

  @override
  List<Object?> get props => [loadLoginStatus, isSubmit, isLoginCountLimit];
}

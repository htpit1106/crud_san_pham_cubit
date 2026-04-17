import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';

class HomeState extends Equatable {
  final AccountEntity? userInfo;
  final bool? onBiometric;

  const HomeState({this.userInfo, this.onBiometric = false});

  HomeState copyWith({AccountEntity? userInfo, bool? onBiometric}) {
    return HomeState(
      userInfo: userInfo ?? this.userInfo,
      onBiometric: onBiometric ?? this.onBiometric,
    );
  }

  @override
  List<Object?> get props => [userInfo, onBiometric];
}

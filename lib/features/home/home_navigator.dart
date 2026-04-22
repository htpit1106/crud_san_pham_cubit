import 'package:go_router/go_router.dart';
import 'package:login_demo/core/base/base_navigator.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/navigator/app_router.dart';

class HomeNavigator extends BaseNavigator {
  HomeNavigator({required super.context});
  Future<bool?> goToAddProduct({ProductEntity? product}) async {
    final result = await context.pushNamed<bool?>(
      AppRouter.addProductName,
      extra: product,
    );
    return result;
  }
}

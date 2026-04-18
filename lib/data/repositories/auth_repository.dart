import 'package:dartz/dartz.dart';
import 'package:login_demo/core/error/failure.dart';
import 'package:login_demo/core/network/api_client.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/entities/token_entity.dart';
import 'package:login_demo/data/model/response/array_response.dart';
import 'package:login_demo/data/model/response/object_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, ObjectResponse<TokenEntity>>> login(
    String username,
    String password,
  );
  Future<Either<Failure, ArrayResponse<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> createCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, void>> updateCategory(int id, CategoryEntity category);

  Future<Either<Failure, ArrayResponse<ProductEntity>>> getProducts({
    int page = 1,
    int? limit = 10,
    String? keyword,
    int? categoryId,
  });
  Future<Either<Failure, void>> createProduct(ProductEntity product);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, void>> updateProduct(int id, ProductEntity product);
}

class AuthRepositoryImpl extends AuthRepository {
  final ApiClient apiClient;
  AuthRepositoryImpl({required this.apiClient});
  @override
  Future<Either<Failure, ObjectResponse<TokenEntity>>> login(
    String username,
    String password,
  ) async {
    try {
      final result = await apiClient.login({
        "username": username,
        "password": password,
      });
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> createCategory(CategoryEntity category) async {
    try {
      await apiClient.createCategory(category);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(ProductEntity product) async {
    try {
      await apiClient.createProduct(product);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await apiClient.deleteCategory(id);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await apiClient.deleteProduct(id);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ArrayResponse<CategoryEntity>>> getCategories() async {
    try {
      final result = await apiClient.getCategories();
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ArrayResponse<ProductEntity>>> getProducts({
    int page = 1,
    int? limit = 10,
    String? keyword,
    int? categoryId,
  }) async {
    try {
      final result = await apiClient.getProducts(
        page: page,
        limit: limit,
        keyword: keyword,
        categoryId: categoryId,
      );
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(
    int id,
    CategoryEntity category,
  ) async {
    try {
      await apiClient.updateCategory(id, category);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
    int id,
    ProductEntity product,
  ) async {
    try {
      await apiClient.updateProduct(id, product);
      return Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}

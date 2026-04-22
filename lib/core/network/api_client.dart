import 'package:dio/dio.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/entities/token_entity.dart';
import 'package:login_demo/data/model/response/array_response.dart';
import 'package:login_demo/data/model/response/object_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/login')
  Future<ObjectResponse<TokenEntity>> login(@Body() Map<String, dynamic> body);

  // Categories API
  @GET('/categories')
  Future<ArrayResponse<CategoryEntity>> getCategories();
  @POST('/categories')
  Future<void> createCategory(@Body() CategoryEntity body);
  @DELETE('/categories/{id}')
  Future<void> deleteCategory(@Path('id') int id);
  @PUT('/categories/{id}')
  Future<void> updateCategory(@Path('id') int id, @Body() CategoryEntity body);

  // Products API
  @GET('/products')
  Future<ArrayResponse<ProductEntity>> getProducts({
    @Query('page') int page = 1,
    @Query('limit') int? limit = 10,
    @Query('keyword') String? keyword,
    @Query('category_id') int? categoryId,
  });
  @POST('/products')
  Future<void> createProduct(@Body() Map<String, dynamic> body);
  @DELETE('/products/{id}')
  Future<void> deleteProduct(@Path('id') int id);
  @PUT('/products/{id}')
  Future<void> updateProduct(@Path('id') int id, @Body() Map<String, dynamic> body);
}

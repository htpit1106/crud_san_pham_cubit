import 'package:equatable/equatable.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/model/enums/product_sort_filter.dart';

enum ProductStatusFilter { all, active, inactive }

class HomeState extends Equatable {
  final AccountEntity? userInfo;
  final bool? onBiometric;
  final LoadStatus loadProductsStatus;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String searchKeyword;
  final int? selectedCategoryId;
  final ProductStatusFilter selectedStatusFilter;
  final ProductSortOption selectedSortOption;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final String? errorMessage;

  const HomeState({
    this.userInfo,
    this.onBiometric = false,
    this.loadProductsStatus = LoadStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.searchKeyword = '',
    this.selectedCategoryId,
    this.selectedStatusFilter = ProductStatusFilter.all,
    this.selectedSortOption = ProductSortOption.latest,
    this.currentPage = 1,
    this.pageSize = 5,
    this.hasMore = true,
    this.errorMessage,
  });

  HomeState copyWith({
    AccountEntity? userInfo,
    bool? onBiometric,
    LoadStatus? loadProductsStatus,
    List<ProductEntity>? products,
    String? searchKeyword,
    int? selectedCategoryId,
    bool clearSelectedCategoryId = false,
    ProductStatusFilter? selectedStatusFilter,
    ProductSortOption? selectedSortOption = ProductSortOption.latest,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      userInfo: userInfo ?? this.userInfo,
      onBiometric: onBiometric ?? this.onBiometric,
      loadProductsStatus: loadProductsStatus ?? this.loadProductsStatus,
      products: products ?? this.products,
      categories: categories,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    userInfo,
    onBiometric,
    loadProductsStatus,
    products,
    categories,
    searchKeyword,
    selectedCategoryId,
    selectedStatusFilter,
    selectedSortOption,
    currentPage,
    pageSize,
    hasMore,
    errorMessage,
  ];
}

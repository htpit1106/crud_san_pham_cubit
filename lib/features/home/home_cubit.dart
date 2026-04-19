import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/model/enums/product_sort_filter.dart';
import 'package:login_demo/data/repositories/product_repository.dart';
import 'package:login_demo/features/home/home_navigator.dart';
import 'package:login_demo/navigator/app_router.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeNavigator navigator;
  final AppCubit appCubit;
  final ProductRepository authRepository;
  HomeCubit({
    required this.navigator,
    required this.appCubit,
    required this.authRepository,
  }) : super(HomeState());

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounce;

  void init() {
    getUserInfo();
    _fetchCategories();
    fetchProducts(reset: true);
    scrollController.addListener(_onScroll);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    return super.close();
  }

  void getUserInfo() async {
    final userInfo = await SecureStorageHelper.instance.getUserInfo();
    emit(state.copyWith(userInfo: userInfo));
  }

  void handleLogout() async {
    await navigator.appDialog.show(
      message: "Bạn có muốn đăng xuất không?",
      textConfirm: "Đăng xuất",
      textCancel: "Huỷ",
      onConfirm: () {
        SecureStorageHelper.instance.refreshStorage();
        emit(state.copyWith(userInfo: null));
        AppRouter.markUnauthenticated();
      },
      onCancel: () {
        navigator.navigateBack();
      },
    );
  }

  Future<void> _fetchCategories() async {
    final result = await authRepository.getCategories();

    result.fold((_) {}, (response) {
      appCubit.setCategories(response.data ?? const []);
    });
  }

  Future<void> fetchProducts({bool reset = false}) async {
    if (state.loadProductsStatus.isLoading ||
        state.loadProductsStatus.isLoadingMore) {
      return;
    }

    final nextPage = reset ? 1 : state.currentPage;
    emit(
      state.copyWith(
        loadProductsStatus: reset ? LoadStatus.loading : LoadStatus.loadingMore,
        products: reset ? const [] : state.products,
        hasMore: reset ? true : state.hasMore,
        errorMessage: null,
        clearErrorMessage: true,
      ),
    );

    final result = await authRepository.getProducts(
      page: nextPage,
      limit: state.pageSize,
      keyword: state.searchKeyword.trim().isEmpty
          ? null
          : state.searchKeyword.trim(),
      categoryId: state.selectedCategoryId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loadProductsStatus: LoadStatus.failure,
            errorMessage: failure.message,
          ),
        );
        navigator.flushbarNavigator.showError(message: failure.message);
      },
      (response) async {
        final fetched = await _filterProductByStatus(
          products: response.data ?? const [],
        );
        final merged = reset ? fetched : [...state.products, ...fetched];
        final sorted = _sortProducts(
          products: merged,
          option: state.selectedSortOption,
        );
        if (sorted == null) {
          emit(
            state.copyWith(
              loadProductsStatus: LoadStatus.failure,
              errorMessage: "Lỗi khi sắp xếp sản phẩm",
            ),
          );
          return;
        }
        final hasMore = fetched.isNotEmpty;
        emit(
          state.copyWith(
            loadProductsStatus: LoadStatus.success,
            products: sorted,
            currentPage: nextPage + 1,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  void onSortChanged(ProductSortOption sortOption) {
    emit(
      state.copyWith(
        selectedSortOption: sortOption,
        products: _sortProducts(option: sortOption, products: state.products),
      ),
    );
  }

  List<ProductEntity>? _sortProducts({
    required List<ProductEntity> products,
    required ProductSortOption option,
  }) {
    final cloned = [...products];
    cloned.sort((a, b) {
      switch (option) {
        case ProductSortOption.nameAsc:
          return ((a.name ?? '').toLowerCase().compareTo(
            (b.name ?? '').toLowerCase(),
          ));

        case ProductSortOption.nameDesc:
          return (b.name ?? '').toLowerCase().compareTo(
            (a.name ?? '').toLowerCase(),
          );
        case ProductSortOption.priceAsc:
          return (a.price ?? 0).compareTo(b.price ?? 0);
        case ProductSortOption.priceDesc:
          return (b.price ?? 0).compareTo(a.price ?? 0);
        case ProductSortOption.stockAsc:
          return (a.stock ?? 0).compareTo(b.stock ?? 0);
        case ProductSortOption.stockDesc:
          return (b.stock ?? 0).compareTo(a.stock ?? 0);
        case ProductSortOption.latest:
          return (b.updatedAt ?? DateTime(1970)).compareTo(
            a.updatedAt ?? DateTime(1970),
          );
      }
    });
    return cloned;
  }

  Future<void> onRefresh() async {
    await fetchProducts(reset: true);
    emit(state.copyWith(currentPage: 1, hasMore: true));
  }

  Future<List<ProductEntity>> _filterProductByStatus({
    required List<ProductEntity> products,
  }) async {
    if (state.selectedStatusFilter == ProductStatusFilter.all) {
      return products;
    }

    return products.where((item) {
      final status = item.status ?? 0;
      if (state.selectedStatusFilter == ProductStatusFilter.active) {
        return status == 1;
      } else {
        return status != 1;
      }
    }).toList();
  }

  void onCategoryChanged(int? categoryId) {
    emit(
      state.copyWith(
        selectedCategoryId: categoryId,
        clearSelectedCategoryId: categoryId == null,
      ),
    );
    fetchProducts(reset: true);
  }

  void onStateusFilterChanged(ProductStatusFilter filter) {
    emit(state.copyWith(selectedStatusFilter: filter));
    fetchProducts(reset: true);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final threshold = 200.0;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (maxScroll - currentScroll <= threshold) {
      if (state.hasMore) {
        fetchProducts();
      }
    }
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(searchKeyword: value));
      fetchProducts(reset: true);
    });
  }

  Future<void> onPressAddProduct() async {
    final result = await navigator.goToAddProduct();
    if (result == true) {
      fetchProducts(reset: true);
      await navigator.flushbarNavigator.showSuccess(
        message: 'Thêm sản phẩm thành công',
      );
    }
  }

  Future<void> onDeleteProduct(int productId) async {
    navigator.appDialog.show(
      message: "Bạn có chắc muốn xoá sản phẩm này không?",
      textConfirm: "Xoá",
      textCancel: "Huỷ",
      onConfirm: () async {
        final result = await authRepository.deleteProduct(productId);
        result.fold(
          (failure) {
            navigator.flushbarNavigator.showError(message: failure.message);
          },
          (response) async {
            fetchProducts(reset: true);
            navigator.navigateBack();
          },
        );
      },
      onCancel: () {
        navigator.navigateBack();
      },
    );
  }
}

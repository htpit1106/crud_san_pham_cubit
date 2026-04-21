import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/global/app_state.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/widget/image/app_svg_image.dart';
import 'package:login_demo/data/model/enums/product_sort_filter.dart';
import 'package:login_demo/features/home/home_navigator.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/features/home/widget/product_card.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        navigator: HomeNavigator(context: context),
        appCubit: context.read(),
        authRepository: context.read(),
      ),
      child: HomePageChild(),
    );
  }
}

class HomePageChild extends StatefulWidget {
  const HomePageChild({super.key});

  @override
  State<HomePageChild> createState() => _HomePageChildState();
}

class _HomePageChildState extends State<HomePageChild> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        actions: [_buildButtonLogout()],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildToolbar(state),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _cubit.onRefresh();
                },
                child: _buildProductContent(state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonLogout() {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.onBiometric != current.onBiometric,
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: AppSvgImage(
                AssetConstants.fingerPrint,
                color: state.onBiometric == true
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            TextButton(
              onPressed: () {
                _cubit.handleLogout();
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToolbar(HomeState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _cubit.searchController,

                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Tìm theo tên sản phẩm...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _cubit.onSearchChanged(value);
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildCategoryFilter(state)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatusFilter(state)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildSortFilter(state)),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _cubit.onPressAddProduct();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm sản phẩm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(HomeState state) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        return DropdownButtonFormField<int?>(
          value: state.selectedCategoryId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Danh mục',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Tất cả danh mục'),
            ),
            if (appState.categories != null)
              ...appState.categories!.map(
                (category) => DropdownMenuItem<int?>(
                  value: category.id,
                  child: Text(category.name ?? 'Không tên'),
                ),
              ),
          ],
          onChanged: (int? value) {
            _cubit.onCategoryChanged(value);
          },
        );
      },
    );
  }

  Widget _buildStatusFilter(HomeState state) {
    return DropdownButtonFormField<ProductStatusFilter>(
      value: state.selectedStatusFilter,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Trạng thái',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: ProductStatusFilter.all,
          child: Text('Tất cả trạng thái'),
        ),
        DropdownMenuItem(
          value: ProductStatusFilter.active,
          child: Text('Active'),
        ),
        DropdownMenuItem(
          value: ProductStatusFilter.inactive,
          child: Text('Inactive'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          _cubit.onStateusFilterChanged(value);
        }
      },
    );
  }

  Widget _buildSortFilter(HomeState state) {
    return DropdownButtonFormField<ProductSortOption>(
      value: state.selectedSortOption,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Sắp xếp',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: ProductSortOption.latest,
          child: Text('Cập nhật mới nhất'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.nameAsc,
          child: Text('Tên A → Z'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.nameDesc,
          child: Text('Tên Z → A'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.priceAsc,
          child: Text('Giá thấp → cao'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.priceDesc,
          child: Text('Giá cao → thấp'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.stockAsc,
          child: Text('Tồn kho thấp → cao'),
        ),
        DropdownMenuItem(
          value: ProductSortOption.stockDesc,
          child: Text('Tồn kho cao → thấp'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          _cubit.onSortChanged(value);
        }
      },
    );
  }

  Widget _buildProductContent(HomeState state) {
    if (state.loadProductsStatus.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.loadProductsStatus == LoadStatus.failure &&
        state.products.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: 320,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Không tải được dữ liệu'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (state.products.isEmpty) {
      return ListView(
        children: const [
          SizedBox(
            height: 320,
            child: Center(child: Text('Chưa có sản phẩm nào')),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _cubit.scrollController,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      itemCount:
          state.products.length +
          (state.loadProductsStatus.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final item = state.products[index];
        return ProductCard(
          item: item,
          onDelete: () => _cubit.onDeleteProduct(item.id ?? -1),
          onEdit: () => _cubit.onPressEditProduct(item),
        );
      },
    );
  }
}

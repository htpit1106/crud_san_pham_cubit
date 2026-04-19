import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/global/app_state.dart';
import 'package:login_demo/core/utils/validator_utils.dart';
import 'package:login_demo/core/widget/button/app_dropdown_button_form_field.dart';
import 'package:login_demo/core/widget/button/app_text_field.dart';
import 'package:login_demo/data/model/entities/category_entity.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/features/home/add_product/add_product_cubit.dart';
import 'package:login_demo/features/home/add_product/add_product_navigator.dart';

class AddProductPage extends StatelessWidget {
  final ProductEntity? productEntity;
  const AddProductPage({super.key, this.productEntity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductCubit>(
      create: (context) => AddProductCubit(
        producRepository: context.read(),
        navigator: AddProductNavigator(context: context),
      ),
      child: AddProductFormSheet(
        categories: context.read<AppCubit>().state.categories,
      ),
    );
  }
}

class AddProductFormSheet extends StatefulWidget {
  final List<CategoryEntity>? categories;

  const AddProductFormSheet({super.key, this.categories = const []});

  @override
  State<AddProductFormSheet> createState() => _AddProductFormSheetState();
}

class _AddProductFormSheetState extends State<AddProductFormSheet> {
  final List<String> _imagePreviews = ['Ảnh 1', 'Ảnh 2'];
  late final AddProductCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<AddProductCubit>();
  }

  @override
  void dispose() {
    _cubit.nameController.dispose();
    _cubit.codeController.dispose();
    _cubit.priceController.dispose();
    _cubit.stockController.dispose();
    _cubit.descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Form(
            key: _cubit.formKey,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.inventory_2_outlined),
                    SizedBox(width: 8),
                    Text(
                      'Thêm sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    controller: _cubit.scrollController,
                    children: [
                      _buildRequiredTextField(
                        controller: _cubit.nameController,
                        label: 'Tên sản phẩm',
                        hint: 'Nhập tên sản phẩm',
                      ),

                      const SizedBox(height: 12),
                      _buildRequiredTextField(
                        controller: _cubit.codeController,
                        label: 'Mã sản phẩm (SKU)',
                        hint: 'VD: SKU-0001',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRequiredTextField(
                              controller: _cubit.priceController,
                              label: 'Giá',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRequiredTextField(
                              controller: _cubit.stockController,
                              label: 'Tồn kho',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<AppCubit, AppState>(
                        buildWhen: (previous, current) =>
                            previous.categories != current.categories,
                        builder: (context, state) {
                          final categoryItems = _buildDistinctCategoryItems(
                            state.categories,
                          );

                          final selectedCategoryId = _resolveCategoryValue(
                            currentValue: _cubit.state.selectedCategoryId,
                            items: categoryItems,
                          );

                          return AppDropdownButtonFormField(
                            value: selectedCategoryId,
                            labelText: 'Danh mục',
                            hintText: 'Chọn danh mục',
                            items: categoryItems,
                            onChanged: (value) {
                              _cubit.onChangeCategory(value);
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 12),
                      AppDropdownButtonFormField(
                        value: _cubit.state.selectedStatus,
                        labelText: 'Trạng thái',
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Kích hoạt')),
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Vô hiệu hóa'),
                          ),
                        ],
                        onChanged: (value) {
                          _cubit.onChangeStatus(value);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildRequiredTextField(
                        controller: _cubit.descriptionController,
                        label: 'Mô tả',
                        hint: 'Nhập mô tả sản phẩm',
                        minLines: 4,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 12),
                      _buildImageSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Huỷ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_cubit.formKey.currentState?.validate() != true) {
                            return;
                          }
                          final success = await _cubit.onSubmit();
                          if (!mounted || !success) return;
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Lưu'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredTextField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    Function(String?)? validator,
    TextEditingController? controller,
    FocusNode? focusNode,
    int? maxLines = 1,
    int? minLines,
  }) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: label,
      hintText: hint,
      validator: (value) =>
          validator?.call(value) ??
          ValidatorUtils.validateRequiredField(value, title: label),

      textInputAction: TextInputAction.next,
      maxLines: maxLines,
      keyboardType: keyboardType,
      minLines: minLines ?? 1,
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ảnh sản phẩm',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Thêm ảnh'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Xem trước / kéo thả sắp xếp (UI demo)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePreviews.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final title = _imagePreviews[index];
                return Container(
                  width: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.drag_indicator, size: 18),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _imagePreviews.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int?>> _buildDistinctCategoryItems(
    List<CategoryEntity>? categories,
  ) {
    final source = categories ?? const <CategoryEntity>[];
    final items = <DropdownMenuItem<int?>>[];
    final seen = <int?>{};

    for (final category in source) {
      final id = category.id;
      if (seen.contains(id)) continue;
      seen.add(id);
      items.add(
        DropdownMenuItem<int?>(value: id, child: Text(category.name ?? '')),
      );
    }

    return items;
  }

  int? _resolveCategoryValue({
    required int? currentValue,
    required List<DropdownMenuItem<int?>> items,
  }) {
    if (currentValue == null) return null;
    final matched = items.where((item) => item.value == currentValue).length;
    return matched == 1 ? currentValue : null;
  }
}

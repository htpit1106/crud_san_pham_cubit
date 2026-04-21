import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:login_demo/core/widget/image/app_cache_image.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity item;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const ProductCard({
    super.key,
    required this.item,
    required this.onDelete,
    this.onEdit,
  });
  @override
  Widget build(BuildContext context) {
    final isActive = (item.status ?? 0) == 1;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEdit,
        child: Card(
          margin: const EdgeInsets.only(top: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? 'Chưa có tên',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('SKU: ${item.code ?? '-'}'),
                      Text('Giá: ${_formatPrice(item.price)} đ'),
                      Text('Tồn kho: ${item.stock ?? 0}'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(isActive ? 'Active' : 'Inactive'),
                            backgroundColor: isActive
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.orange.withValues(alpha: 0.16),
                          ),
                          if (item.updatedAt != null)
                            Chip(
                              label: Text(
                                'Cập nhật: ${_formatDate(item.updatedAt!)}',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  tooltip: 'Xoá',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if ((item.image ?? '').isEmpty) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.image!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 72,
          height: 72,
          color: Colors.grey.shade200,
          child: AppCacheImage(path: item.image ?? '', fit: BoxFit.cover),
        ),
      ),
    );
  }

  static String _formatDate(DateTime input) {
    final day = input.day.toString().padLeft(2, '0');
    final month = input.month.toString().padLeft(2, '0');
    return '$day/$month/${input.year}';
  }

  static String _formatPrice(double? value) {
    final number = (value ?? 0).toStringAsFixed(0);
    final chars = number.split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join();
  }
}

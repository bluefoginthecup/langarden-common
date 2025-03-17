// lib/langarden_common/multi_select_actions.dart
import 'package:flutter/material.dart';
import 'icon_button.dart';

class MultiSelectActions extends StatelessWidget {
  final bool allSelected;
  final VoidCallback onToggleSelectAll;
  final VoidCallback? onTrash;
  final VoidCallback? onRestore;
  final VoidCallback? onCart;
  final VoidCallback? onLearn;

  const MultiSelectActions({
    super.key,
    required this.allSelected,
    required this.onToggleSelectAll,
    this.onTrash,
    this.onRestore,
    this.onCart,
    this.onLearn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppIconButton(
          icon: Icons.select_all,
          onPressed: onToggleSelectAll,
        ),
        if (onTrash != null)
        AppIconButton(
          icon: Icons.delete,
          onPressed: onTrash ?? () {},
        ),
        if (onRestore != null)
        AppIconButton(
          icon: Icons.restore_from_trash,
          onPressed: onRestore ?? () {},
        ),
        if (onCart != null)
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: onCart ?? () {},
          ),
        if (onLearn != null)
          AppIconButton(
              icon: Icons.video_library,
              onPressed: onLearn ?? () {},
            ),//kk
      ],
    );
  }
}

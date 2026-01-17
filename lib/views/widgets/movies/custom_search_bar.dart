import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_size.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/search_viewmodel.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final vm = context.watch<SearchViewModel>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.w(3)),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        onChanged: (val) {
          vm.updateQuery(val);
          onChanged?.call(val);
        },
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: "TV shows, movies and more",
          hintStyle: const TextStyle(fontSize: 12),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: vm.isSearching
              ? GestureDetector(
            onTap: () {
              controller.clear();
              vm.clearQuery();
              onClear?.call();
            },
            child: const Icon(Icons.close),
          )
              : null,
        ),
      ),
    );
  }
}

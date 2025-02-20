import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/widget/searchable_listview.dart';

mixin AsyncBottomSheetAction {
  Future<void> showCustomFutureListBottomsheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext context, T item, int index)
        itemBuilder,
    required AutoDisposeFutureProvider<List<T>> listProvider,
    required bool Function(T, String) filter,
    Widget? customEmptyWidget,
    Widget Function(BuildContext context)? extraTopItemBuilder,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Add this to ensure the bottom sheet resizes with keyboard
      useSafeArea: true,
      builder: (context) {
        // Wrap with Padding to handle keyboard
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CustomBottomSheet<T>(
            itemBuilder: itemBuilder,
            listProvider: listProvider,
            filter: filter,
            customEmptyWidget: customEmptyWidget,
            extraTopItemBuilder: extraTopItemBuilder,
          ),
        );
      },
    );
    log("Sheet Dismissed");
  }
}

class CustomBottomSheet<T> extends ConsumerWidget {
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final AutoDisposeFutureProvider<List<T>> listProvider;
  final bool Function(T, String) filter;
  final Widget? customEmptyWidget;
  final Widget Function(BuildContext context)? extraTopItemBuilder;

  const CustomBottomSheet({
    super.key,
    required this.itemBuilder,
    required this.listProvider,
    required this.filter,
    this.customEmptyWidget,
    this.extraTopItemBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      // Adjust initial size to be smaller when keyboard is visible
      initialChildSize:
          MediaQuery.of(context).viewInsets.bottom > 0 ? 0.9 : 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Expanded(
                child: SearchableListView<T>(
                  itemBuilder: itemBuilder,
                  listProvider: listProvider,
                  filter: filter,
                  customEmptyWidget: customEmptyWidget,
                  extraTopItemBuilder: extraTopItemBuilder,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A generic dropdown selector widget for selecting an item from a list.
// It can handle asynchronous data fetching using Riverpod.
class GenericDropdownSelector<T> extends ConsumerWidget {
  const GenericDropdownSelector({
    super.key,
    required this.hintText,
    required this.subTitle,
    required this.itemsProvider,
    required this.textEditingController,
    required this.itemBuilder,
    required this.filter,
    this.validator,
    this.decoration,
    this.suffixIcon,
  });

  final String hintText;
  final String subTitle;
  final AutoDisposeFutureProvider<List<T>> itemsProvider;
  final TextEditingController textEditingController;
  final Widget Function(BuildContext context, T entity, bool isSelected)
  itemBuilder;
  final bool Function(T entity, String searchText) filter;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        _showSelectionScreen(context, ref);
      },
      child: AbsorbPointer(
        // AbsorbPointer prevents the default TextFormField tap behavior
        child: TextFormField(
          controller: textEditingController,
          readOnly: true, // Make it non-editable
          decoration: decoration ??
              InputDecoration(
                hintText: hintText,
                labelText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: suffixIcon ?? const Icon(Icons.arrow_drop_down),
              ),
          validator: validator,
        ),
      ),
    );
  }

  void _showSelectionScreen(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => SelectionScreen<T>(
          subTitle: subTitle,
          itemsProvider: itemsProvider,
          itemBuilder: itemBuilder,
          filter: filter,
        ),
      ),
    );
  }
}

// A screen to display the list of items for selection, with a search bar.
class SelectionScreen<T> extends ConsumerStatefulWidget {
  const SelectionScreen({
    super.key,
    required this.subTitle,
    required this.itemsProvider,
    required this.itemBuilder,
    required this.filter,
  });

  final String subTitle;
  final AutoDisposeFutureProvider<List<T>> itemsProvider;
  final Widget Function(BuildContext context, T entity, bool isSelected)
  itemBuilder;
  final bool Function(T entity, String searchText) filter;

  @override
  ConsumerState<SelectionScreen<T>> createState() => _SelectionScreenState<T>();
}

class _SelectionScreenState<T> extends ConsumerState<SelectionScreen<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncItems = ref.watch(widget.itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: asyncItems.when(
        data: (items) {
          final filteredItems = items
              .where((item) => widget.filter(item, _searchText))
              .toList();
          if (filteredItems.isEmpty && _searchText.isNotEmpty) {
            return const Center(child: Text('No matching items found.'));
          } else if (filteredItems.isEmpty) {
            return const Center(child: Text('No items available.'));
          }
          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              // For the purpose of this generic example, isSelected is always false
              // You would typically pass the currently selected value from the parent widget
              // and compare it here to set isSelected.
              return widget.itemBuilder(context, item, false);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
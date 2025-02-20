import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _searchQueryProvider =
    StateNotifierProvider.autoDispose<SearchableListViewStateNotifier, String>(
        (ref) {
  return SearchableListViewStateNotifier('');
});

class SearchableListViewStateNotifier extends StateNotifier<String> {
  SearchableListViewStateNotifier(super.state);

  search(String data) {
    state = data;
  }
}

class SearchableListView<T> extends ConsumerWidget {
  const SearchableListView({
    super.key,
    required this.itemBuilder,
    required this.listProvider,
    required this.filter,
    this.customEmptyWidget,
    this.extraTopItemBuilder,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final AutoDisposeFutureProvider<List<T>> listProvider;
  final bool Function(T, String) filter;
  final Widget? customEmptyWidget;
  final Widget Function(BuildContext context)? extraTopItemBuilder;

  Future<void> _refresh(WidgetRef refreshRef) async {
    return refreshRef.refresh(listProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(listProvider);
    final searchQuery = ref.watch(_searchQueryProvider);
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Skeletonizer(
            enabled: dataAsync.isLoading,
            child: TextField(
              autofocus: false,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onChanged: (value) =>
                  ref.read(_searchQueryProvider.notifier).search(value),
            ),
          ),
        ),
        Expanded(
          child: dataAsync.when(
            data: (data) {
              if (dataAsync.isRefreshing) {
                return SizedBox(
                  height: width,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              final filteredData =
                  data.where((item) => filter(item, searchQuery)).toList();

              if (filteredData.isEmpty && extraTopItemBuilder == null) {
                return Center(
                    child: customEmptyWidget ?? const Text("Not found"));
              } else {
                return RefreshIndicator(
                  onRefresh: () => _refresh(ref),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.black12,
                    ),
                    itemCount: filteredData.length +
                        (extraTopItemBuilder != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && extraTopItemBuilder != null) {
                        return extraTopItemBuilder!(context);
                      }
                      final dataIndex =
                          extraTopItemBuilder != null ? index - 1 : index;
                      return itemBuilder(
                        context,
                        filteredData[dataIndex],
                        dataIndex,
                      );
                    },
                  ),
                );
              }
            },
            error: (error, s) {
              if (dataAsync.isRefreshing) {
                return SizedBox(
                  height: width,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              return const Text("Failed");
            },
            loading: () => SizedBox(
              height: width,
              child: Skeletonizer(
                enabled: true,
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (b, i) {
                      return ListTile(
                        title: Text(
                          "Loading Data here it is ...........",
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          "Loading Data here it is ...........",
                          maxLines: 1,
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

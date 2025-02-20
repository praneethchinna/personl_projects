import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ysr_project/features/widget/custom_bottom_sheet_action.dart';

class AsyncDropdownSelector<T> extends ConsumerStatefulWidget
    with AsyncBottomSheetAction {
  final String hintText;
  final String subTitle;
  final String? Function(String?)? validator;
  final AutoDisposeFutureProvider<List<T>> itemsProvider;
  final bool Function(T, String) filter;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? customEmptyWidget;
  final Widget Function(BuildContext context)? extraTopItemBuilder;
  final TextEditingController textEditingController;
  // Add these new properties
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const AsyncDropdownSelector({
    super.key,
    required this.hintText,
    required this.subTitle,
    this.validator,
    required this.itemsProvider,
    required this.filter,
    required this.itemBuilder,
    this.customEmptyWidget,
    this.extraTopItemBuilder,
    required this.textEditingController,
    // Add these to the constructor
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  ConsumerState<AsyncDropdownSelector> createState() =>
      AsyncDropdownSelectorState<T>();
}

class AsyncDropdownSelectorState<T>
    extends ConsumerState<AsyncDropdownSelector<T>> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  String? _errorText;

  @override
  void initState() {
    textEditingController = widget.textEditingController;
    textEditingController.addListener(_validateOnChange);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.removeListener(_validateOnChange);
    super.dispose();
  }

  void _validateOnChange() {
    setState(() {
      _errorText = widget.validator?.call(textEditingController.text);
    });
  }

  bool validate() {
    setState(() {
      _errorText = widget.validator?.call(textEditingController.text);
    });
    return _errorText == null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.showCustomFutureListBottomsheet<T>(
          context: context,
          itemBuilder: widget.itemBuilder,
          listProvider: widget.itemsProvider,
          filter: widget.filter,
        );
        validate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.subTitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AbsorbPointer(
                    child: TextFormField(
                      controller: textEditingController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        alignLabelWithHint: true,
                        suffixIcon:
                            const Icon(Icons.keyboard_arrow_down_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        errorText: _errorText,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

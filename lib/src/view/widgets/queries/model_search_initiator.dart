import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';
import '../../../services/http/http_service_factory.dart';
import '../../../typedefs.dart';
import 'search_popup_delegate.dart';

typedef SearchSelectionBuilder<SM extends ShortModel> = //
    Widget Function(BuildContext context, SM? selected);

typedef SingleChildTapDetector = Widget Function({
  required Widget child,
  required VoidCallback onTap,
});

typedef ModelSearchInitiatorConstructor<K, SM extends ShortModel<K>> = //
    ModelSearchInitiator<K, SM> Function(
        {required UpdateCallback<K?> onUpdate,
        SM? selected,
        WidgetBuilder progressIndicatorBuilder,
        SearchSelectionBuilder<SM> selectionBuilder,
        SingleChildTapDetector container,
        Key? key,
        bool preserveSearchOnCancel,
        String searchHint});

SearchSelectionBuilder<SM> selectionBuilderWithPlaceholder<K, SM extends ShortModel<K>>(
        String placeholder) =>
    (context, selected) => defaultSelectionBuilder(context, selected, placeholder: placeholder);

Widget defaultSelectionBuilder(
  BuildContext context,
  ShortModel? selected, {
  String placeholder = 'Вибрати',
}) {
  return Text(selected != null ? selected.descriptiveAttr : placeholder);
}

Widget defaultProgressIndicatorBuilder(BuildContext context) =>
    const FittedBox(child: CircularProgressIndicator());

class ModelSearchInitiator<K, SM extends ShortModel<K>> extends StatefulWidget {
  final UpdateCallback<K?> onUpdate;
  final WidgetBuilder progressIndicatorBuilder;
  final SearchSelectionBuilder<SM> selectionBuilder;
  final SingleChildTapDetector container;
  final SM? selected;
  final bool preserveSearchOnCancel;
  final String? searchHint;

  const ModelSearchInitiator({
    required this.onUpdate,
    this.selected,
    this.progressIndicatorBuilder = defaultProgressIndicatorBuilder,
    this.selectionBuilder = defaultSelectionBuilder,
    this.container = InkWell.new,
    this.preserveSearchOnCancel = true,
    this.searchHint,
    super.key,
  });

  @override
  State<ModelSearchInitiator<K, SM>> createState() => _ModelSearchInitiatorState<K, SM>();
}

class _ModelSearchInitiatorState<K, SM extends ShortModel<K>>
    extends State<ModelSearchInitiator<K, SM>> {
  late final httpService = makeShortModelHttpService<SM>();
  late final List<SM> options;
  bool isLoaded = false;
  bool isLoading = false;
  Object? error;
  late SM? selection = widget.selected;

  @override
  Widget build(BuildContext context) {
    return widget.container(
      onTap: processTap,
      child: buildContent(),
    );
  }

  Widget buildContent() {
    if (error != null) {
      return Text('$error');
    }

    if (isLoading) {
      return widget.progressIndicatorBuilder(context);
    }

    return widget.selectionBuilder(context, selection);
  }

  Future<void> processTap() async {
    if (isLoading) return;
    if (!isLoaded) return await fetchOptions();
    if (!mounted) return;

    var selection = await showSearch(
      context: context,
      delegate: SearchPopupDelegate<SM>(options, widget.searchHint),
    );

    if (widget.preserveSearchOnCancel) {
      selection ??= this.selection;
    }

    if (!mounted) return;
    setState(() => this.selection = selection);
    widget.onUpdate(selection?.primaryKey);
  }

  Future<void> fetchOptions() {
    return httpService.get().then(
      (options) {
        if (!mounted) return;
        _setStateIfNotMounted(() {
          this.options = options;
          isLoaded = true;
          isLoading = false;
        });
        processTap();
      },
    ).catchError(
      (err) {
        _setStateIfNotMounted(() => this.error = err);
      },
    );
  }

  void _setStateIfNotMounted(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }
}

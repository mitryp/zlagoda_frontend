import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../typedefs.dart';
import '../../../../utils/locales.dart';
import '../../../pages/page_base.dart';
import 'model_table.dart';

class ModelView<M extends Model> extends StatefulWidget {
  final ResourceFetchFunction<M> fetchFunction;

  const ModelView({required this.fetchFunction, super.key});

  @override
  State<ModelView<M>> createState() => _ModelViewState<M>();
}

class _ModelViewState<M extends Model> extends State<ModelView<M>> {
  late final M model;
  late final List<ModelTable> connectedModelTables;
  bool isResourceLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

  void fetchResources() async {
    model = await widget.fetchFunction();
    connectedModelTables = await Future.wait(model.connectedTables.map((f) => f.call()));

    if (!mounted) return;
    setState(() => isResourceLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!isResourceLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageBase.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableHeader(makeModelLocalizedName(model.runtimeType)),
        const Padding(padding: EdgeInsets.only(top: 8)),
        ModelTable(model, showModelName: false),
        if (connectedModelTables.isNotEmpty) buildConnectedModels(),
      ],
    );
  }

  Widget buildConnectedModels() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TableHeader('Пов\'язані моделі'),
          Flex(
            direction: Axis.horizontal,
            children: connectedModelTables.map(EmbeddedModelTableCard.new).toList(),
          ),
        ],
      ),
    );
  }
}

class EmbeddedModelTableCard<M extends Model> extends StatelessWidget {
  final ModelTable<M> child;

  const EmbeddedModelTableCard(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 12),
        child: child,
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  final String text;

  const TableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8).copyWith(left: 20),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
    );
  }
}

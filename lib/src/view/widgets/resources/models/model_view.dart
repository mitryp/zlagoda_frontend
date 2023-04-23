import 'package:flutter/material.dart';

import '../../../../model/basic_models/employee.dart';
import '../../../../model/interfaces/model.dart';
import '../../../../theme.dart';
import '../../../../typedefs.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/locales.dart';
import '../../../pages/page_base.dart';
import '../../permissions/authorizer.dart';
import '../../text_link.dart';
import 'model_edit_view.dart';
import 'model_table.dart';

class ModelView<M extends Model> extends StatefulWidget {
  final ResourceFetchFunction<M> fetchFunction;
  final List<ModelTable>? connectedTables;

  const ModelView({required this.fetchFunction, this.connectedTables, super.key});

  @override
  State<ModelView<M>> createState() => _ModelViewState<M>();
}

class _ModelViewState<M extends Model> extends State<ModelView<M>> {
  late final M model;
  late final List<ModelTable> connectedModelTables;
  bool isResourceLoaded = false;
  ResourceNotFetchedException? exception;

  @override
  void initState() {
    super.initState();

    fetchResources();
  }

  Future<void> fetchResources() async {
    try {
      model = await widget.fetchFunction();
    } on ResourceNotFetchedException catch (e) {
      if (!mounted) return;
      return setState(() => exception = e);
    }
    connectedModelTables = widget.connectedTables ??
        await Future.wait(model.foreignKeys
            .where((fk) => fk.reference.isConnected)
            .map((fk) => fk.tableGenerator()));

    if (!mounted) return;
    setState(() => isResourceLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (exception != null) {
      return buildErrorMessage();
    }
    if (!isResourceLoaded) {
      return buildLoadingPlaceholder();
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: PageBase.row(
          bodyPadding: const EdgeInsets.all(25),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableHeader(makeModelLocalizedName<M>(model.runtimeType)),
                ModelTable(model, showModelName: false),
              ],
            ),
            if (connectedModelTables.isNotEmpty) ...[
              const SizedBox(width: 125),
              buildConnectedModels(),
            ],
          ],
        ),
      ),
      floatingActionButton: buildEditButton(),
    );
  }

  Widget buildLoadingPlaceholder() => const Center(child: CircularProgressIndicator());

  Widget buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Помилка при завантаженні: ${exception!.message}'),
          TextLink.text(
            text: const Text('Повернутися назад'),
            onTap: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }

  Widget buildConnectedModels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TableHeader("Пов'язані ресурси"),
        ...connectedModelTables.map(EmbeddedModelTableCard.new),
      ],
    );
  }

  Widget buildEditButton() {
    return Authorizer.emptyUnauthorized(
      authorizationStrategy: hasPosition(Position.manager),
      child: ElevatedButton.icon(
        label: const Text('Редагувати'),
        icon: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ModelEditForm<M>(
              model: model,
            ),
          ));
        },
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
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: () => child.redirectToModelView(context),
        child: Padding(
          padding: const EdgeInsets.all(8).copyWith(top: 12),
          child: child,
        ),
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

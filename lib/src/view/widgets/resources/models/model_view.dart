import 'package:flutter/material.dart';

import '../../../../model/basic_models/category.dart';
import '../../../../model/basic_models/client.dart';
import '../../../../model/basic_models/employee.dart';
import '../../../../model/basic_models/product.dart';
import '../../../../model/basic_models/receipt.dart';
import '../../../../model/basic_models/store_product.dart';
import '../../../../model/interfaces/model.dart';
import '../../../../services/auth/user.dart';
import '../../../../theme.dart';
import '../../../../typedefs.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/locales.dart';
import '../../../../utils/navigation.dart';
import '../../../../utils/value_status.dart';
import '../../../dialogs/usages/show_prom_creation_dialog.dart';
import '../../../pages/page_base.dart';
import '../../auth/authorizer.dart';
import '../../auth/user_manager.dart';
import '../../text_link.dart';
import '../../utils/helping_functions.dart';
import 'model_table.dart';

class ModelView<M extends Model> extends StatefulWidget {
  final ResourceFetchFunction<M> fetchFunction;
  final List<ModelTable>? connectedTables;
  final List<WidgetBuilder>? additionalButtonsBuilders;

  const ModelView({
    required this.fetchFunction,
    this.connectedTables,
    this.additionalButtonsBuilders,
    super.key,
  });

  @override
  State<ModelView<M>> createState() => ModelViewState<M>();
}

class ModelViewState<M extends Model> extends State<ModelView<M>> {
  late M model;
  late List<ModelTable> connectedModelTables;
  bool isResourceLoaded = false;
  ResourceNotFetchedException? exception;
  ValueStatusWrapper<M> changeStatus = ValueStatusWrapper.notChanged();

  UserAuthorizationStrategy get authStrategy =>
      ([StoreProduct, Product, Receipt, Client, Employee, Category].contains(M))
          ? hasUser
          : hasPosition(Position.manager);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (authStrategy.call(UserManager.of(context).currentUser)) fetchResources();
  }

  Future<void> fetchResources({bool fetchModel = true, bool fetchConnectedTables = true}) async {
    setState(() {
      isResourceLoaded = false;
      exception = null;
    });
    if (fetchModel) {
      try {
        model = await widget.fetchFunction();
      } on ResourceNotFetchedException catch (e) {
        print(e);
        if (!mounted) return;
        return setState(() => exception = e);
      }
    }

    var connectedTables = fetchConnectedTables ? null : widget.connectedTables;
    connectedModelTables = connectedTables ??
        await Future.wait(model.foreignKeys
            .where((fk) => fk.reference.isConnected)
            .map((fk) => fk.tableGenerator()));

    if (!mounted) return;
    setState(() => isResourceLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserManager.of(context).currentUser;
    Widget? guard;

    if (exception != null) {
      guard = buildErrorMessage();
    } else if (!isResourceLoaded) {
      guard = buildLoadingPlaceholder();
    } else if (!authStrategy.call(currentUser) &&
        model is! Employee &&
        (model as Employee).employeeId != currentUser?.userId) {
      guard = Authorizer.noPermissionPlaceholder;
    }

    if (guard != null) {
      return Scaffold(
        appBar: AppBar(),
        body: guard,
      );
    }

    return Authorizer(
      authorizationStrategy: authStrategy,
      child: WillPopScope(
        onWillPop: () async {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.of(context).pop(changeStatus));
          return false;
        },
        child: buildContent(),
      ),
    );
  }

  Scaffold buildContent() {
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
      floatingActionButton: buildButtonSection(context),
    );
  }

  Widget buildButtonSection(BuildContext context) {
    return widget.additionalButtonsBuilders != null
        ? Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            children: makeSeparated([
              ...widget.additionalButtonsBuilders!.map((builder) => builder(context)),
              buildEditButton(),
            ]))
        : buildEditButton();
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
        ...connectedModelTables.map(
          (e) => EmbeddedModelTableCard(e, onUpdate: (status) {
            if (!mounted || status.status == ValueChangeStatus.notChanged) return;
            changeStatus = ValueStatusWrapper<M>(status.status, model);
            fetchResources(fetchModel: false, fetchConnectedTables: true);
          }),
        ),
      ],
    );
  }

  Widget buildEditButton() {
    final model = this.model;

    final VoidCallback onPressed;
    if (model is! StoreProduct || !model.isProm) {
      onPressed = _processEditPress;
    } else {
      onPressed = _processStoreProductEditPress;
    }

    return Authorizer.emptyUnauthorized(
      authorizationStrategy: (User? user) =>
          (M == Client && hasUser(user)) ||
          (hasPosition(Position.manager).call(user) && M != Receipt),
      child: ElevatedButton.icon(
        label: const Text('Редагувати'),
        icon: const Icon(Icons.edit),
        onPressed: onPressed,
      ),
    );
  }

  void _processEditPress() async {
    final future = AppNavigation.of(context).openModelEditViewFor<M>(
      model,
      connectedModels: connectedModelTables.map((t) => t.model).toList(),
    );
    _processModelChange(future);
  }

  void _processStoreProductEditPress() async {
    final future = showPromCreationDialog(context, model as StoreProduct)
        .then((v) => v ?? ValueStatusWrapper<StoreProduct>.notChanged());

    _processModelChange(future as Future<ValueStatusWrapper<M>>);
  }

  void _processModelChange(
    Future<ValueStatusWrapper<M>> wrappedOperation, {
    bool fetchMainModel = false,
  }) async {
    final statusWrapper = await wrappedOperation;

    final status = statusWrapper.status;

    if (!mounted || status == ValueChangeStatus.notChanged) return;
    changeStatus = statusWrapper;
    if (status == ValueChangeStatus.deleted || status == ValueChangeStatus.created) {
      return Navigator.of(context).pop(statusWrapper);
    }
    model = statusWrapper.value!;
    fetchResources(fetchModel: fetchMainModel, fetchConnectedTables: !fetchMainModel);
  }
}

class EmbeddedModelTableCard<M extends Model> extends StatelessWidget {
  final ModelTable<M> child;
  final UpdateCallback<ValueStatusWrapper<M>> onUpdate;

  const EmbeddedModelTableCard(this.child, {required this.onUpdate, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: () async => onUpdate(await child.redirectToModelView(context)),
        child: Padding(
          padding: const EdgeInsets.all(8).copyWith(top: 12),
          child: child,
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.only(top: 8, bottom: 8, left: 20);

  final String text;
  final TextStyle style;
  final EdgeInsetsGeometry padding;

  const TableHeader(
    this.text, {
    this.style = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    this.padding = defaultPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

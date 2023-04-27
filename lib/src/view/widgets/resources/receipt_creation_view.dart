import 'package:flutter/material.dart';

import '../../../model/basic_models/receipt.dart';
import '../../../model/schema/validators.dart';
import '../../../model/search_models/short_client.dart';
import '../../../model/search_models/short_store_product.dart';
import '../../../services/http/helpers/http_service_factory.dart';
import '../../../services/http/helpers/http_service_helper.dart';
import '../../../services/middleware/response/response_display_middleware.dart';
import '../../../theme.dart';
import '../../../typedefs.dart';
import '../../../utils/json_decode.dart';
import '../../../utils/value_status.dart';
import '../queries/model_search_initiator.dart';
import 'models/model_view.dart';

class ReceiptCreationView extends StatefulWidget {
  const ReceiptCreationView({super.key});

  @override
  State<ReceiptCreationView> createState() => _ReceiptCreationViewState();
}

class _ReceiptCreationViewState extends State<ReceiptCreationView> {
  late final List<ShortStoreProduct> productOptions;
  bool isLoaded = false;
  Object? error;

  String? clientId;
  final List<SaleInput> sales = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchOptions();
  }

  Future<void> fetchOptions() async {
    final service = makeShortModelHttpService<ShortStoreProduct>();

    try {
      productOptions = await service.get();
      if (!mounted) return;
      setState(() => isLoaded = true);
    } catch (err) {
      if (!mounted) return;
      setState(() => error = err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (error != null) {
      body = Center(
        child: Text('$error'),
      );
    } else {
      body = !isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : buildBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Створення чеку'),
      ),
      body: body,
      floatingActionButton: isLoaded ? buildCreateButton() : null,
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: FractionallySizedBox(
          widthFactor: .5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                buildClientSelector(),
                const SizedBox(height: 16),
                const TableHeader(
                  'Товари у чеку',
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  shrinkWrap: true,
                  itemCount: sales.length + 1,
                  itemBuilder: (context, index) {
                    if (index == sales.length) {
                      return buildAddSaleButton();
                    }
                    return sales[index];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCreateButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.create),
      label: const Text('Створити'),
      onPressed: processCreation,
    );
  }

  void processCreation() async {
    final json = generateJson();
    print(json);
    if (json == null) return;

    final res = await _postReceipt(json);
    if (!mounted || res == null) return;
    Navigator.of(context).pop(ValueStatusWrapper<Receipt>.created(res));
  }

  Map<String, dynamic>? generateJson() {
    final messenger = ScaffoldMessenger.of(context);

    if (!formKey.currentState!.validate()) {
      return null;
    }

    final salesJson = sales.map((s) => s.toJson()).where((e) => e != null).toList();
    if (salesJson.isEmpty) {
      messenger.showSnackBar(statusSnackBar(
        'Список продажів не може бути порожнім (впевніться, '
        'що ви обрали товари для всіх продажів)',
        isSuccess: false,
      ));
      return null;
    }

    return {
      'clientId': clientId,
      'sales': salesJson,
    };
  }

  Widget buildAddSaleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
      child: ElevatedButton(
        onPressed: () {
          final key = GlobalKey<_SaleInputState>();

          final input = SaleInput(
            key: key,
            initialOptions: productOptions,
            onChanged: (sale) {
              print('onChanged ${sale?.storeProductPk} ${sale?.price}');
            },
            onRemoved: () => setState(() => sales.removeWhere((s) => s.key == key)),
          );

          setState(() => sales.add(input));
        },
        child: const Text('Додати товар'),
      ),
    );
  }

  Widget buildClientSelector() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        color: secondary.withOpacity(.1),
      ),
      child: ModelSearchInitiator<String, ShortClient>(
        preserveSearchOnCancel: false,
        selectionBuilder: (context, selected) {
          const commonStyle = TextStyle(fontSize: 16);

          if (selected == null) {
            return const Text(
              'Обрати картку постійного клієнта (за наявності)',
              style: commonStyle,
            );
          }
          return Text.rich(
            TextSpan(
              style: commonStyle,
              children: [
                const TextSpan(text: 'Покупець:  '),
                TextSpan(
                  text: selected.descriptiveAttr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
        onUpdate: (newValue) {
          if (!mounted) return;
          setState(() => clientId = newValue);
        },
        container: ({required child, required onTap}) {
          return InkWell(
            borderRadius: defaultBorderRadius,
            onTap: onTap,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              )
            ]),
          );
        },
      ),
    );
  }
}

class SaleInput extends StatefulWidget {
  final List<ShortStoreProduct> initialOptions;

  // should also validate the form
  final UpdateCallback<SaleData?> onChanged;
  final VoidCallback onRemoved;

  const SaleInput({
    required this.initialOptions,
    required this.onChanged,
    required this.onRemoved,
    super.key,
  });

  @override
  State<SaleInput> createState() => _SaleInputState();

  Map<String, dynamic>? toJson() {
    final state = (key as GlobalKey<_SaleInputState>).currentState!;
    final quantity = int.parse(state.quantityController.text);
    final id = state.selectionPk;
    if (id == null) return null;

    return {
      'storeProductId': id,
      'quantity': quantity,
    };
  }
}

class _SaleInputState extends State<SaleInput> {
  late final TextEditingController quantityController = TextEditingController();
  int? selectionPk;

  void propagateChange() {
    final quantity = int.tryParse(quantityController.text);
    final pk = selectionPk;
    print('quantity: $quantity, pk $pk');

    if (quantity == null || pk == null) return widget.onChanged(null);

    widget.onChanged(SaleData(pk, quantity));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(mainAxisSize: MainAxisSize.min, children: [
        buildProductSelector(),
        const SizedBox(width: 24),
        buildPriceField(),
      ]),
      trailing: IconButton(
        icon: const Icon(Icons.remove),
        onPressed: widget.onRemoved,
      ),
    );
  }

  Widget buildProductSelector() {
    return Expanded(
      child: ModelSearchInitiator<int, ShortStoreProduct>(
        externalOptions: widget.initialOptions,
        onUpdate: (newPk) {
          print('new value $newPk');
          if (newPk == null) return;
          selectionPk = newPk;
          propagateChange();
        },
        selectionBuilder: selectionBuilderWithPlaceholder('Обрати товар'),
        container: ({required child, required onTap}) {
          return InkWell(
              borderRadius: defaultBorderRadius,
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: primary.withOpacity(.2),
                  borderRadius: defaultBorderRadius,
                ),
                padding: const EdgeInsets.all(8),
                child: child,
              ));
        },
      ),
    );
  }

  Widget buildPriceField() {
    return Expanded(
      child: TextFormField(
        controller: quantityController,
        decoration: const InputDecoration(label: Text('Кількість')),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: isPositiveInteger,
        onChanged: (value) => propagateChange(),
      ),
    );
  }
}

class SaleData {
  final int storeProductPk;
  final int price;

  const SaleData(this.storeProductPk, this.price);
}

Future<Receipt?> _postReceipt(JsonMap json) async {
  final res = await makeRequest(
    HttpMethod.post,
    Uri.http(baseRoute, 'api/receipts'),
    body: json,
  );

  return httpServiceController(
    res,
    (response) => Receipt.fromJson(decodeResponseBody<Map<String, dynamic>>(response)),
    (response) => null,
  );
}

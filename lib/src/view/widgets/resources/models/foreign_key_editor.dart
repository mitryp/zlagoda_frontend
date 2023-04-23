import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/model_reference.dart';
import '../../../../theme.dart';
import '../../../../utils/locales.dart';

typedef UpdateCallback<T> = void Function(T newForeignKey);

class ForeignKeyEditor<M extends Model> extends StatefulWidget {
  final ForeignKey<M> initialForeignKey;
  final M? initiallyConnectedModel;
  final UpdateCallback<dynamic> updateCallback;

  const ForeignKeyEditor({
    required this.updateCallback,
    required this.initialForeignKey,
    this.initiallyConnectedModel,
    super.key,
  });

  @override
  State<ForeignKeyEditor<M>> createState() => _ForeignKeyEditorState<M>();
}

class _ForeignKeyEditorState<M extends Model> extends State<ForeignKeyEditor<M>> {
  M? connectedModel;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    if (widget.initiallyConnectedModel == null) {
      fetchCurrentConnectedValue();
    } else {
      connectedModel = widget.initiallyConnectedModel;
      setState(() => isLoaded = true);
    }
  }

  Future<void> fetchCurrentConnectedValue() async {
    if (!widget.initialForeignKey.reference.isConnected) {
      return setState(() {
        isLoaded = true;
        connectedModel = null;
      });
    }

    connectedModel = await widget.initialForeignKey.reference.fetch();

    if (!mounted) return;
    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    late Widget cardChild;
    if (!isLoaded) {
      cardChild = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      cardChild = InkWell(
        onTap: () {}, // todo
        borderRadius: defaultBorderRadius,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FittedBox(
                child: Text(
                  connectedModel != null ? '$connectedModel' : makeModelLocalizedName<M>(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(child: cardChild);
  }
}

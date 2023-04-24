import 'package:flutter/material.dart';

import '../../../../model/interfaces/model.dart';
import '../../../../model/interfaces/search_model.dart';
import '../../../../model/model_reference.dart';
import '../../../../theme.dart';

typedef UpdateCallback<T> = void Function(T newForeignKey);

class ForeignKeyEditor<M extends Model, SM extends ShortModel> extends StatefulWidget {
  final ForeignKey<M, SM> initialForeignKey;
  final M? initiallyConnectedModel;
  final UpdateCallback<dynamic> updateCallback;

  const ForeignKeyEditor({
    required this.updateCallback,
    required this.initialForeignKey,
    this.initiallyConnectedModel,
    super.key,
  });

  @override
  State<ForeignKeyEditor<M, SM>> createState() => _ForeignKeyEditorState<M, SM>();
}

class _ForeignKeyEditorState<M extends Model, SM extends ShortModel>
    extends State<ForeignKeyEditor<M, SM>> {
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
      cardChild = widget.initialForeignKey.searchInitiator(
        onUpdate: widget.updateCallback,
        selected: connectedModel?.toSearchModel() as SM?,
        container: ({required child, required onTap}) => InkWell(
          borderRadius: defaultBorderRadius,
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              )
            ],
          ),
        ),
      );
    }

    return Card(child: cardChild);
  }
}

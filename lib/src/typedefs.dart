import 'dart:async';

import 'package:flutter/material.dart';

import 'model/interfaces/model.dart';
import 'view/widgets/resources/models/model_table.dart';

typedef FetchFunction = Future<List<dynamic>> Function(dynamic queryBuilder);

typedef JsonMap = Map<String, dynamic>;

typedef JsonModelCast<M extends Model> = M Function(dynamic json);

typedef ResourceFetchFunction<M extends Model> = FutureOr<M> Function();

typedef ModelTableGenerator<M extends Model> = Future<ModelTable<M>> Function();

typedef Constructor<T> = T Function();
typedef VoidWidgetConstructor<T extends Widget> = T Function({Key? key});
typedef RedirectCallback = void Function(BuildContext context);

typedef ExactWidgetBuilder<W extends Widget> = W Function(BuildContext context);

// Row or Column
typedef FlexContainerType = Function({
  List<Widget> children,
  CrossAxisAlignment crossAxisAlignment,
  Key? key,
  MainAxisAlignment mainAxisAlignment,
  MainAxisSize mainAxisSize,
  TextBaseline? textBaseline,
  TextDirection? textDirection,
  VerticalDirection verticalDirection,
});

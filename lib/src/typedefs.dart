import 'dart:async';

import 'model/interfaces/model.dart';
import 'view/widgets/resources/models/model_table.dart';

typedef FetchFunction = Future<List<dynamic>> Function(dynamic queryBuilder);

typedef JsonMap = Map<String, dynamic>;

// TODO change dynamic into JSON type
typedef JsonModelCast<M extends Model> = M Function(dynamic json);

typedef ResourceFetchFunction<M extends Model> = FutureOr<M> Function();

typedef ModelTableGenerator<M extends Model> = Future<ModelTable<M>> Function();

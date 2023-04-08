import '../../typedefs.dart';
import '../interfaces/serializable.dart';

abstract class Model implements Serializable {
  const Model();

  dynamic get primaryKey;

  List<ModelTableGenerator> get connectedTables => [];
}

import '../interfaces/serializable.dart';
import '../model_reference.dart';

abstract class Model implements Serializable {
  const Model();

  dynamic get primaryKey;

  List<ForeignKey> get foreignKeys => [];
}

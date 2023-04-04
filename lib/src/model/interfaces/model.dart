import '../interfaces/serializable.dart';

abstract class Model extends Serializable{
  const Model();

  dynamic get primaryKey;
}

typedef Schema = Map<String, dynamic Function(Map<String, dynamic> value)>;

abstract class Serializable {
  Map<String, dynamic> toJSON();
}
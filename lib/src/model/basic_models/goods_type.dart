import '../interfaces/model.dart';

class GoodsType implements Model {
  final int typeId;
  final String name;
  final String manufacturer;
  final String specs;
  final bool categoryId;

  const GoodsType({
    required this.typeId,
    required this.name,
    required this.manufacturer,
    required this.specs,
    required this.categoryId,
  });

  factory GoodsType.fromJSON(dynamic json) {
    return GoodsType(
      typeId: json['typeId'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      specs: json['specs'],
      categoryId: json['categoryId'],
    );
  }

  @override
  get primaryKey => typeId;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'typeId': typeId,
      'name': name,
      'manufacturer': manufacturer,
      'specs': specs,
      'categoryId': categoryId,
    };
  }
}

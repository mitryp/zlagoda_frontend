import '../../../model/interfaces/serializable.dart';

class CollectionSliceWrapper<I extends Serializable> {
  final List<I> items;
  final int totalCount;

  CollectionSliceWrapper({required this.items, required this.totalCount});
}
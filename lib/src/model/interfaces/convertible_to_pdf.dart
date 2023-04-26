import 'convertibles_helper.dart';
import 'serializable.dart';

mixin ConvertibleToPdf<R extends ConvertibleToPdf<R>> on Serializable {
  List<dynamic> get row => rowValues<R>(this as R).toList();

  List<String> get columns => columnNamesOf<R>().toList();
}

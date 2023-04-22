// class TransactionFilterChip extends StatelessWidget {
//   final FilterChangeCallback? onSelected;
//   final VoidCallback? resetFilterCallback;
//   final VoidCallback? onTap;
//   final Widget label;
//   final bool selected;
//   final Color? backgroundColor;
//   final Color? selectedColor;
//
//   const TransactionFilterChip({
//     required this.label,
//     required this.onSelected,
//     this.selected = false,
//     this.resetFilterCallback,
//     this.onTap,
//     this.backgroundColor,
//     this.selectedColor,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final filter = FilterChip(
//       label: label,
//       onSelected: onSelected,
//       selected: selected,
//       backgroundColor: backgroundColor,
//       selectedColor: selectedColor,
//     );
//
//     if (resetFilterCallback == null && onTap == null) return filter;
//
//     return GestureDetector(
//       onTap: onTap,
//       onLongPress: resetFilterCallback,
//       child: filter,
//     );
//   }
// }
//
//
// class DropdownFilterChip<T> extends StatefulWidget {
//   static const chipTextStyle = TextStyle(fontWeight: FontWeight.w500);
//
//   final TCallback<T?>? onChanged;
//   final T? value;
//   final Widget? icon;
//   final List<DropdownMenuItem<T>>? items;
//   final VoidCallback? onLongPress;
//   final FilterChangeCallback? onSelected;
//   final VoidCallback? resetFilterCallback;
//   final bool selected;
//   final Color? backgroundColor;
//   final Color? selectedColor;
//
//   const DropdownFilterChip({
//     required this.onChanged,
//     required this.items,
//     this.selected = false,
//     this.onSelected,
//     this.onLongPress,
//     this.resetFilterCallback,
//     this.value,
//     this.icon,
//     this.backgroundColor,
//     this.selectedColor,
//     super.key,
//   });
//
//   @override
//   State<DropdownFilterChip<T>> createState() => _DropdownFilterChipState<T>();
// }
//
// class _DropdownFilterChipState<T> extends State<DropdownFilterChip<T>> {
//   final GlobalKey dropdownKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => openDropdownButton(dropdownKey),
//       onLongPress: widget.onLongPress,
//       child: AbsorbPointer(
//         ignoringSemantics: false,
//         child: TransactionFilterChip(
//           selectedColor: widget.selectedColor,
//           backgroundColor: widget.backgroundColor,
//           onSelected: widget.onSelected ?? (value) {},
//           selected: widget.selected,
//           resetFilterCallback: widget.resetFilterCallback,
//           label: DropdownButton<T>(
//             key: dropdownKey,
//             style: const TextStyle(color: Colors.black),
//             isDense: true,
//             onChanged: widget.onChanged,
//             value: widget.value,
//             icon: widget.icon,
//             underline: const SizedBox(),
//             items: widget.items,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// void openDropdownButton(GlobalKey dropdownKey) {
//   if (dropdownKey.currentContext == null) return;
//   _findGestureDetector(dropdownKey.currentContext!)?.onTap!.call();
// }
//
// GestureDetector? _findGestureDetector(BuildContext context) {
//   GestureDetector? res;
//   void search(BuildContext context) {
//     context.visitChildElements((element) {
//       if (res != null) return;
//       if (element.widget is GestureDetector) {
//         res = element.widget as GestureDetector;
//       } else {
//         search(element);
//       }
//     });
//   }
//
//   search(context);
//   return res;
// }
//
// DropdownFilterChip<MoneyFlowDirection>
// (
// onChanged: (value) => setFilters(
// () =>
// setState(() => moneyFlowDirectionFilter = value ?? moneyFlowDirectionFilter),
// ),
// icon: const SizedBox(),
// value: moneyFlowDirectionFilter,
// items: MoneyFlowDirection.values.map(buildDirectionMenuItem).toList(),
// )
//
// DropdownMenuItem<MoneyFlowDirection> buildDirectionMenuItem(MoneyFlowDirection e) {
// return DropdownMenuItem(
// alignment: Alignment.center,
// value: e,
// child: e.iconFor(context),
// );
// }
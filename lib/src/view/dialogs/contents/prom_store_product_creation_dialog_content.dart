import 'package:flutter/material.dart';

import '../../../model/schema/validators.dart';

class PromStoreProductTextField extends StatefulWidget {
  final TextEditingController controller;
  final FieldValidator validator;

  const PromStoreProductTextField({
    required this.controller,
    required this.validator,
    super.key,
  });
  
  @override
  State<PromStoreProductTextField> createState() => _PromStoreProductTextFieldState();
}

class _PromStoreProductTextFieldState extends State<PromStoreProductTextField> {
  @override
  Widget build(BuildContext context) {
      return TextFormField(
        decoration: const InputDecoration(label: Text('Кількість акційного товару')),
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.always,
      );
  }
}
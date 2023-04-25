import 'package:flutter/material.dart';

import '../../../model/schema/validators.dart';

class PromStoreProductCreation extends StatefulWidget {
  final TextEditingController controller;
  final FieldValidator validator;

  const PromStoreProductCreation({
    required this.controller,
    required this.validator,
    super.key,
  });
  
  @override
  State<PromStoreProductCreation> createState() => _PromStoreProductCreationState();
}

class _PromStoreProductCreationState extends State<PromStoreProductCreation> {
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
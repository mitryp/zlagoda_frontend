import 'package:flutter/material.dart';

class ReceiptCreationView extends StatefulWidget {
  const ReceiptCreationView({super.key});

  @override
  State<ReceiptCreationView> createState() => _ReceiptCreationViewState();
}

class _ReceiptCreationViewState extends State<ReceiptCreationView> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Створення чеку'),
        ),
        body: Column(children: [
          // todo
        ]),
      );
  }
}
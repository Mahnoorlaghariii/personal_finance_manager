import 'package:flutter/material.dart';

class KVRow extends StatelessWidget {
final String label;
final String value;
const KVRow({super.key, required this.label, required this.value});


@override
Widget build(BuildContext context) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
],
);
}
}